// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.4.25 <=0.8.15;

import "./typeLibraries/MarketTypes.sol";

/// @title Filecoin market actor API for Solidity.
/// @author Zondax AG
/// @notice It is mock with specific scenarios based on the parameters used to call its methods. It is meant to serve as the first entry point, and be replaced seamlessly in the future by the real API implementation tath actually calls the filecoin actor.
/// @dev Most of function calls are currently implemented using some kind of struct for parameters and returns.
contract MarketAPI {
    mapping(string => uint256) balances;
    mapping(uint64 => MarketTypes.MockDeal) deals;

    constructor() {
        generate_deal_mocks();
    }

    /// @param params MarketTypes.AddBalanceParams
    function add_balance(
        MarketTypes.AddBalanceParams memory params
    ) public payable {
        balances[params.provider_or_client] += msg.value;
    }

    /// @param params MarketTypes.WithdrawBalanceParams
    function withdraw_balance(
        MarketTypes.WithdrawBalanceParams memory params
    ) public returns (MarketTypes.WithdrawBalanceReturn memory) {
        uint256 tmp = balances[params.provider_or_client];
        if (balances[params.provider_or_client] >= params.tokenAmount) {
            balances[params.provider_or_client] -= params.tokenAmount;
            tmp = params.tokenAmount;
        } else {
            balances[params.provider_or_client] = 0;
        }

        return MarketTypes.WithdrawBalanceReturn(tmp);
    }

    /// @param addr string
    function get_balance(
        string memory addr
    ) public view returns (MarketTypes.GetBalanceReturn memory) {
        uint256 actualBalance = balances[addr];

        return MarketTypes.GetBalanceReturn(actualBalance, 0);
    }

    // FIXME set data values correctly
    /// @param params MarketTypes.GetDealDataCommitmentParams
    function get_deal_data_commitment(
        MarketTypes.GetDealDataCommitmentParams memory params
    ) public view returns (MarketTypes.GetDealDataCommitmentReturn memory) {
        require(deals[params.id].id > 0);

        return
            MarketTypes.GetDealDataCommitmentReturn(
                bytes("0x111111"),
                deals[params.id].size
            );
    }

    /// @param params MarketTypes.GetDealClientParams
    function get_deal_client(
        MarketTypes.GetDealClientParams memory params
    ) public view returns (MarketTypes.GetDealClientReturn memory) {
        require(deals[params.id].id > 0);

        return MarketTypes.GetDealClientReturn(deals[params.id].client);
    }

    /// @param params MarketTypes.GetDealProviderParams
    function get_deal_provider(
        MarketTypes.GetDealProviderParams memory params
    ) public view returns (MarketTypes.GetDealProviderReturn memory) {
        require(deals[params.id].id > 0);

        return MarketTypes.GetDealProviderReturn(deals[params.id].provider);
    }

    /// @param params MarketTypes.GetDealLabelParams
    function get_deal_label(
        MarketTypes.GetDealLabelParams memory params
    ) public view returns (MarketTypes.GetDealLabelReturn memory) {
        require(deals[params.id].id > 0);

        return MarketTypes.GetDealLabelReturn(deals[params.id].label);
    }

    /// @param params MarketTypes.GetDealTermParams
    function get_deal_term(
        MarketTypes.GetDealTermParams memory params
    ) public view returns (MarketTypes.GetDealTermReturn memory) {
        require(deals[params.id].id > 0);

        return
            MarketTypes.GetDealTermReturn(
                deals[params.id].start,
                deals[params.id].end
            );
    }

    /// @param params MarketTypes.GetDealEpochPriceParams
    function get_deal_epoch_price(
        MarketTypes.GetDealEpochPriceParams memory params
    ) public view returns (MarketTypes.GetDealEpochPriceReturn memory) {
        require(deals[params.id].id > 0);

        return
            MarketTypes.GetDealEpochPriceReturn(
                deals[params.id].price_per_epoch
            );
    }

    /// @param params MarketTypes.GetDealClientCollateralParams
    function get_deal_client_collateral(
        MarketTypes.GetDealClientCollateralParams memory params
    ) public view returns (MarketTypes.GetDealClientCollateralReturn memory) {
        require(deals[params.id].id > 0);

        return
            MarketTypes.GetDealClientCollateralReturn(
                deals[params.id].client_collateral
            );
    }

    /// @param params MarketTypes.GetDealProviderCollateralParams
    function get_deal_provider_collateral(
        MarketTypes.GetDealProviderCollateralParams memory params
    ) public view returns (MarketTypes.GetDealProviderCollateralReturn memory) {
        require(deals[params.id].id > 0);

        return
            MarketTypes.GetDealProviderCollateralReturn(
                deals[params.id].provider_collateral
            );
    }

    /// @param params MarketTypes.GetDealVerifiedParams
    function get_deal_verified(
        MarketTypes.GetDealVerifiedParams memory params
    ) public view returns (MarketTypes.GetDealVerifiedReturn memory) {
        require(deals[params.id].id > 0);

        return MarketTypes.GetDealVerifiedReturn(deals[params.id].verified);
    }

    /// @param params MarketTypes.GetDealActivationParams
    function get_deal_activation(
        MarketTypes.GetDealActivationParams memory params
    ) public view returns (MarketTypes.GetDealActivationReturn memory) {
        require(deals[params.id].id > 0);

        return
            MarketTypes.GetDealActivationReturn(
                deals[params.id].activated,
                deals[params.id].terminated
            );
    }

    function publish_deal(bytes memory raw_auth_params, address callee) public {
        // calls standard filecoin receiver on message authentication api method number
        (bool success, ) = callee.call(
            abi.encodeWithSignature(
                "handle_filecoin_method(uint64,uint64,bytes)",
                0,
                2643134072,
                raw_auth_params
            )
        );
        require(success, "client contract failed to authorize deal publish");
    }

    function generate_deal_mocks() internal {
        MarketTypes.MockDeal memory deal_67;
        deal_67.id = 67;
        deal_67
            .cid = "baga6ea4seaqlkg6mss5qs56jqtajg5ycrhpkj2b66cgdkukf2qjmmzz6ayksuci";
        deal_67.size = 8388608;
        deal_67.verified = false;
        deal_67.client = "t01109";
        deal_67.provider = "t01113";
        deal_67.label = "mAXCg5AIg8YBXbFjtdBy1iZjpDYAwRSt0elGLF5GvTqulEii1VcM";
        deal_67.start = 25245;
        deal_67.end = 545150;
        deal_67.price_per_epoch = 1100000000000;
        deal_67.provider_collateral = 0;
        deal_67.client_collateral = 0;
        deal_67.activated = 1;
        deal_67.terminated = 0;

        deals[deal_67.id] = deal_67;

        MarketTypes.MockDeal memory deal_68;
        deal_68.id = 68;
        deal_68
            .cid = "baga6ea4seaqiun7s6npsi23ujt55qclad2rkxy44hx5thrmllgdl5pbcv32gsky";
        deal_68.size = 4194304;
        deal_68.verified = false;
        deal_68.client = "t01109";
        deal_68.provider = "t01113";
        deal_68.label = "mAXCg5AIg4KyGboe+GUQSZFtHmtUnk2IcXbaRFl4V1YOmC9vgoms";
        deal_68.start = 25249;
        deal_68.end = 545150;
        deal_68.price_per_epoch = 1700000000000;
        deal_68.provider_collateral = 0;
        deal_68.client_collateral = 0;
        deal_68.activated = 1;
        deal_68.terminated = 0;

        deals[deal_68.id] = deal_68;

        MarketTypes.MockDeal memory deal_69;
        deal_69.id = 69;
        deal_69
            .cid = "baga6ea4seaqftmfuagbtycvrcskaol64eyio3dnzpjbllpwvwkv2nd5lqdiymby";
        deal_69.size = 8388608;
        deal_69.verified = false;
        deal_69.client = "t01109";
        deal_69.provider = "t01113";
        deal_69.label = "mAXCg5AIgxXsZaQ0qnC01BIARoPmPYa/qOOoI5se/a+R5PfUTV2g";
        deal_69.start = 25246;
        deal_69.end = 545150;
        deal_69.price_per_epoch = 1200000000000;
        deal_69.provider_collateral = 0;
        deal_69.client_collateral = 0;
        deal_69.activated = 1;
        deal_69.terminated = 0;

        deals[deal_69.id] = deal_69;

        MarketTypes.MockDeal memory deal_70;
        deal_70.id = 70;
        deal_70
            .cid = "baga6ea4seaqastxji7jl5lgnnkcrqrmacaghmxjsgif6dose77ggmn2dkwpnqoq";
        deal_70.size = 8388608;
        deal_70.verified = false;
        deal_70.client = "t01109";
        deal_70.provider = "t01113";
        deal_70.label = "mAXCg5AIgn6xPVzAVUsugSuUtyJkSdzakFc17R5LxQ0+ql2RpTpI";
        deal_70.start = 25246;
        deal_70.end = 545150;
        deal_70.price_per_epoch = 1300000000000;
        deal_70.provider_collateral = 0;
        deal_70.client_collateral = 0;
        deal_70.activated = 1;
        deal_70.terminated = 0;

        deals[deal_70.id] = deal_70;

        MarketTypes.MockDeal memory deal_71;
        deal_71.id = 71;
        deal_71
            .cid = "baga6ea4seaqn7y7fwlhlshrysd2j443pyi6knof2c5qp533co2mqj5rzbq7t2pi";
        deal_71.size = 8388608;
        deal_71.verified = false;
        deal_71.client = "t01109";
        deal_71.provider = "t01113";
        deal_71.label = "mAXCg5AIgw4oywPmiPRxJLioYxMdIkKmaJ4FFumCvS/GC4gEzGng";
        deal_71.start = 25247;
        deal_71.end = 545150;
        deal_71.price_per_epoch = 1400000000000;
        deal_71.provider_collateral = 0;
        deal_71.client_collateral = 0;
        deal_71.activated = 1;
        deal_71.terminated = 0;

        deals[deal_71.id] = deal_71;

        MarketTypes.MockDeal memory deal_72;
        deal_72.id = 72;
        deal_72
            .cid = "baga6ea4seaqdl6geodjdraqwh56yqewcub4pxnlxsc7673xnfazhctawun22aha";
        deal_72.size = 4194304;
        deal_72.verified = false;
        deal_72.client = "t01109";
        deal_72.provider = "t01113";
        deal_72.label = "mAXCg5AIglPFhEfVlJwt+dkvz/JNQ8BakUxmAZb1dQ8F0sKnHeFE";
        deal_72.start = 25248;
        deal_72.end = 545150;
        deal_72.price_per_epoch = 1600000000000;
        deal_72.provider_collateral = 0;
        deal_72.client_collateral = 0;
        deal_72.activated = 1;
        deal_72.terminated = 0;

        deals[deal_72.id] = deal_72;

        MarketTypes.MockDeal memory deal_73;
        deal_73.id = 73;
        deal_73
            .cid = "baga6ea4seaqcxlx2n7wvk45vl5eqrocvfnpkxbdnsi3bv3u5lwowxjirlgt7wgy";
        deal_73.size = 4194304;
        deal_73.verified = false;
        deal_73.client = "t01109";
        deal_73.provider = "t01113";
        deal_73.label = "mAXCg5AIgmsykC9fRbd/zT76TR4zK42g520tAsRzr9+w4MeT4sJc";
        deal_73.start = 25250;
        deal_73.end = 545150;
        deal_73.price_per_epoch = 1800000000000;
        deal_73.provider_collateral = 0;
        deal_73.client_collateral = 0;
        deal_73.activated = 1;
        deal_73.terminated = 0;

        deals[deal_73.id] = deal_73;

        MarketTypes.MockDeal memory deal_74;
        deal_74.id = 74;
        deal_74
            .cid = "baga6ea4seaqcxsr53negpkklyb4p6pojm2726yrr34lszn5j7qiacc7htv7vueq";
        deal_74.size = 16777216;
        deal_74.verified = false;
        deal_74.client = "t01109";
        deal_74.provider = "t01113";
        deal_74.label = "mAXCg5AIgmtJq7yh1JTsGJkPrA1hLaSnXZIE+MfeeP1bT8OOGb4A";
        deal_74.start = 25248;
        deal_74.end = 545150;
        deal_74.price_per_epoch = 1500000000000;
        deal_74.provider_collateral = 0;
        deal_74.client_collateral = 0;
        deal_74.activated = 1;
        deal_74.terminated = 0;

        deals[deal_74.id] = deal_74;

        MarketTypes.MockDeal memory deal_75;
        deal_75.id = 75;
        deal_75
            .cid = "baga6ea4seaqlkg6mss5qs56jqtajg5ycrhpkj2b66cgdkukf2qjmmzz6ayksuci";
        deal_75.size = 8388608;
        deal_75.verified = false;
        deal_75.client = "t01109";
        deal_75.provider = "t01113";
        deal_75.label = "mAXCg5AIg8YBXbFjtdBy1iZjpDYAwRSt0elGLF5GvTqulEii1VcM";
        deal_75.start = 25802;
        deal_75.end = 545150;
        deal_75.price_per_epoch = 1100000000000;
        deal_75.provider_collateral = 0;
        deal_75.client_collateral = 0;
        deal_75.activated = 1;
        deal_75.terminated = 0;

        deals[deal_75.id] = deal_75;

        MarketTypes.MockDeal memory deal_76;
        deal_76.id = 76;
        deal_76
            .cid = "baga6ea4seaqftmfuagbtycvrcskaol64eyio3dnzpjbllpwvwkv2nd5lqdiymby";
        deal_76.size = 8388608;
        deal_76.verified = false;
        deal_76.client = "t01109";
        deal_76.provider = "t01113";
        deal_76.label = "mAXCg5AIgxXsZaQ0qnC01BIARoPmPYa/qOOoI5se/a+R5PfUTV2g";
        deal_76.start = 25802;
        deal_76.end = 545150;
        deal_76.price_per_epoch = 1200000000000;
        deal_76.provider_collateral = 0;
        deal_76.client_collateral = 0;
        deal_76.activated = 1;
        deal_76.terminated = 0;

        deals[deal_76.id] = deal_76;

        MarketTypes.MockDeal memory deal_77;
        deal_77.id = 77;
        deal_77
            .cid = "baga6ea4seaqastxji7jl5lgnnkcrqrmacaghmxjsgif6dose77ggmn2dkwpnqoq";
        deal_77.size = 8388608;
        deal_77.verified = false;
        deal_77.client = "t01109";
        deal_77.provider = "t01113";
        deal_77.label = "mAXCg5AIgn6xPVzAVUsugSuUtyJkSdzakFc17R5LxQ0+ql2RpTpI";
        deal_77.start = 25803;
        deal_77.end = 545150;
        deal_77.price_per_epoch = 1300000000000;
        deal_77.provider_collateral = 0;
        deal_77.client_collateral = 0;
        deal_77.activated = 1;
        deal_77.terminated = 0;

        deals[deal_77.id] = deal_77;

        MarketTypes.MockDeal memory deal_78;
        deal_78.id = 78;
        deal_78
            .cid = "baga6ea4seaqdl6geodjdraqwh56yqewcub4pxnlxsc7673xnfazhctawun22aha";
        deal_78.size = 4194304;
        deal_78.verified = false;
        deal_78.client = "t01109";
        deal_78.provider = "t01113";
        deal_78.label = "mAXCg5AIglPFhEfVlJwt+dkvz/JNQ8BakUxmAZb1dQ8F0sKnHeFE";
        deal_78.start = 25803;
        deal_78.end = 545150;
        deal_78.price_per_epoch = 1600000000000;
        deal_78.provider_collateral = 0;
        deal_78.client_collateral = 0;
        deal_78.activated = 1;
        deal_78.terminated = 0;

        deals[deal_78.id] = deal_78;

        MarketTypes.MockDeal memory deal_79;
        deal_79.id = 79;
        deal_79
            .cid = "baga6ea4seaqiun7s6npsi23ujt55qclad2rkxy44hx5thrmllgdl5pbcv32gsky";
        deal_79.size = 4194304;
        deal_79.verified = false;
        deal_79.client = "t01109";
        deal_79.provider = "t01113";
        deal_79.label = "mAXCg5AIg4KyGboe+GUQSZFtHmtUnk2IcXbaRFl4V1YOmC9vgoms";
        deal_79.start = 25803;
        deal_79.end = 545150;
        deal_79.price_per_epoch = 1700000000000;
        deal_79.provider_collateral = 0;
        deal_79.client_collateral = 0;
        deal_79.activated = 1;
        deal_79.terminated = 0;

        deals[deal_79.id] = deal_79;

        MarketTypes.MockDeal memory deal_80;
        deal_80.id = 80;
        deal_80
            .cid = "baga6ea4seaqcxlx2n7wvk45vl5eqrocvfnpkxbdnsi3bv3u5lwowxjirlgt7wgy";
        deal_80.size = 4194304;
        deal_80.verified = false;
        deal_80.client = "t01109";
        deal_80.provider = "t01113";
        deal_80.label = "mAXCg5AIgmsykC9fRbd/zT76TR4zK42g520tAsRzr9+w4MeT4sJc";
        deal_80.start = 25804;
        deal_80.end = 545150;
        deal_80.price_per_epoch = 1800000000000;
        deal_80.provider_collateral = 0;
        deal_80.client_collateral = 0;
        deal_80.activated = 1;
        deal_80.terminated = 0;

        deals[deal_80.id] = deal_80;

        MarketTypes.MockDeal memory deal_81;
        deal_81.id = 81;
        deal_81
            .cid = "baga6ea4seaqn7y7fwlhlshrysd2j443pyi6knof2c5qp533co2mqj5rzbq7t2pi";
        deal_81.size = 8388608;
        deal_81.verified = false;
        deal_81.client = "t01109";
        deal_81.provider = "t01113";
        deal_81.label = "mAXCg5AIgw4oywPmiPRxJLioYxMdIkKmaJ4FFumCvS/GC4gEzGng";
        deal_81.start = 25803;
        deal_81.end = 545150;
        deal_81.price_per_epoch = 1400000000000;
        deal_81.provider_collateral = 0;
        deal_81.client_collateral = 0;
        deal_81.activated = 1;
        deal_81.terminated = 0;

        deals[deal_81.id] = deal_81;

        MarketTypes.MockDeal memory deal_82;
        deal_82.id = 82;
        deal_82
            .cid = "baga6ea4seaqcxsr53negpkklyb4p6pojm2726yrr34lszn5j7qiacc7htv7vueq";
        deal_82.size = 16777216;
        deal_82.verified = false;
        deal_82.client = "t01109";
        deal_82.provider = "t01113";
        deal_82.label = "mAXCg5AIgmtJq7yh1JTsGJkPrA1hLaSnXZIE+MfeeP1bT8OOGb4A";
        deal_82.start = 25803;
        deal_82.end = 545150;
        deal_82.price_per_epoch = 1500000000000;
        deal_82.provider_collateral = 0;
        deal_82.client_collateral = 0;
        deal_82.activated = 1;
        deal_82.terminated = 0;

        deals[deal_82.id] = deal_82;
    }
}
