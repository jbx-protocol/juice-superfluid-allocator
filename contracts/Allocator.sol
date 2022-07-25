// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
import '@jbx-protocol-v2/contracts/interfaces/IJBSplitAllocator.sol';
import '@jbx-protocol-v2/contracts/libraries/JBTokens.sol';
import '@jbx-protocol-v2/contracts/structs/JBSplitAllocationData.sol';

import {ISuperfluid} from '@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol'; //"@superfluid-finance/ethereum-monorepo/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {IConstantFlowAgreementV1} from '@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol';

import {CFAv1Library} from '@superfluid-finance/ethereum-contracts/contracts/apps/CFAv1Library.sol';

import {ISuperfluid, ISuperToken, ISuperApp, ISuperAgreement, SuperAppDefinitions} from '@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol'; //"@superfluid-finance/ethereum-monorepo/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

/**
 @title
 Juicebox split allocator

 @notice
 This is an allocator template, used as a recipient of a payout split, to add an extra layer of logic in fund allocation
*/
contract JBSuperfluidAllocator is ERC165, IJBSplitAllocator {
  error NOT_SUPPORTED_YET();

  //initialize cfaV1 variable
  CFAv1Library.InitData public cfaV1;

  int96 public flowRate;

  constructor(ISuperfluid _host, int96 _flowRate) {
    flowRate = _flowRate;

    //initialize InitData struct, and set equal to cfaV1
    cfaV1 = CFAv1Library.InitData(
      _host,
      //here, we are deriving the address of the CFA using the host contract
      IConstantFlowAgreementV1(
        address(
          _host.getAgreementClass(
            keccak256('org.superfluid-finance.agreements.ConstantFlowAgreement.v1')
          )
        )
      )
    );
  }

  //@inheritdoc IJBAllocator
  function allocate(JBSplitAllocationData calldata _data) external payable override {
    if (_data.token != JBTokens.ETH) revert NOT_SUPPORTED_YET();

    // TODO wrap incoming ETH as ETHX using https://github.com/superfluid-finance/protocol-monorepo/blob/dev/packages/ethereum-contracts/contracts/tokens/SETH.sol.
    ISuperToken _ethx = address(0);

    // Do something with the fund received

    (, int96 _currentFlowRate, , ) = cfaV1.cfa.getFlow(
      _ethx,
      address(this),
      _data.split.beneficiary
    );

    if (_currentFlowRate == 0) cfaV1.createFlow(_data.split.beneficiary, _ethx, _flowRate);
    else cfaV1.updateFlow(_data.split.beneficiary, _ethx, _flowRate);
  }

  function supportsInterface(bytes4 _interfaceId)
    public
    view
    override(IERC165, ERC165)
    returns (bool)
  {
    return
      _interfaceId == type(IJBSplitAllocator).interfaceId || super.supportsInterface(_interfaceId);
  }
}
