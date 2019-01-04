import Foundation
import Yosemite

/// Site-wide settings for displaying prices/money
///
public class CurrencySettings {
    /// Shared Instance
    ///
    static var shared = CurrencySettings()

    // MARK: - Enums


    /// The 3-letter country code for supported currencies
    ///
    public enum CurrencyCode: String {
        case AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BRL, BSD, BTC, BTN, BWP, BYR, BYN, BZD, CAD, CDF, CHF, CLP, CNY, COP, CRC, CUC, CUP, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GGP, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, IMP, INR, IQD, IRR, IRT, ISK, JEP, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRO, MUR, MVR, MWK, MXN, MYR, MZN, NAD, NGN, NIO, NOK, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PRB, PYG, QAR, RMB, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL, SOS, SRD, SSP, STD, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UAH, UGX, USD, UYU, UZS, VEF, VND, VUV, WST, XAF, XCD, XOF, XPF, YER, ZAR, ZMW
    }

    /// Designates where the currency symbol is located on a formatted price
    ///
    public enum CurrencyPosition: String {
        case left = "left"
        case right = "right"
        case leftSpace = "left_space"
        case rightSpace = "right_space"
    }

    /// Default currency settings
    ///
    public enum Default {
        static let code = CurrencyCode.USD
        static let position = CurrencyPosition.left
        static let thousandSeparator = ","
        static let decimalSeparator = "."
        static let decimalPosition = 2
    }


    // MARK: - Variables

    /// Public variables, privately set
    ///
    public private(set) var currencyCode: CurrencyCode
    public private(set) var currencyPosition: CurrencyPosition
    public private(set) var thousandSeparator: String
    public private(set) var decimalSeparator: String
    public private(set) var numberOfDecimals: Int

    /// ResultsController: Whenever settings change, I will change. We both change. The world changes.
    ///
    private lazy var resultsController: ResultsController<StorageSiteSetting> = {
        let storageManager = AppDelegate.shared.storageManager

        let resultsController = ResultsController<StorageSiteSetting>(storageManager: storageManager, sectionNameKeyPath: nil, sortedBy: [])

        resultsController.onDidChangeObject = { [weak self] (object, indexPath, type, newIndexPath) in
            self?.updateCurrencyOptions(with: object)
        }

        return resultsController
    }()

    /// Returns the currency symbol associated with the specified country code.
    ///
    public func symbol(from code: CurrencyCode) -> String {
        // HTML entities and currency codes pulled from WC:
        // https://docs.woocommerce.com/wc-apidocs/source-function-get_woocommerce_currency.html#473
        switch code {
        case .AED:
            return "&#x62f;.&#x625;".strippedHTML
        case .AFN:
            return "&#x60b;".strippedHTML
        case .ALL:
            return "L".strippedHTML
        case .AMD:
            return "AMD".strippedHTML
        case .ANG:
            return "&fnof;".strippedHTML
        case .AOA:
            return "Kz".strippedHTML
        case .ARS:
            return "&#36;".strippedHTML
        case .AUD:
            return "&#36;".strippedHTML
        case .AWG:
            return "Afl.".strippedHTML
        case .AZN:
            return "AZN".strippedHTML
        case .BAM:
            return "KM".strippedHTML
        case .BBD:
            return "&#36;".strippedHTML
        case .BDT:
            return "&#2547;&nbsp;".strippedHTML
        case .BGN:
            return "&#1083;&#1074;.".strippedHTML
        case .BHD:
            return ".&#x62f;.&#x628;".strippedHTML
        case .BIF:
            return "Fr".strippedHTML
        case .BMD:
            return "&#36;".strippedHTML
        case .BND:
            return "&#36;".strippedHTML
        case .BOB:
            return "Bs.".strippedHTML
        case .BRL:
            return "&#82;&#36;".strippedHTML
        case .BSD:
            return "&#36;".strippedHTML
        case .BTC:
            return "&#3647;".strippedHTML
        case .BTN:
            return "Nu.".strippedHTML
        case .BWP:
            return "P".strippedHTML
        case .BYR:
            return "Br".strippedHTML
        case .BYN:
            return "Br".strippedHTML
        case .BZD:
            return "&#36;".strippedHTML
        case .CAD:
            return "&#36;".strippedHTML
        case .CDF:
            return "Fr".strippedHTML
        case .CHF:
            return "&#67;&#72;&#70;".strippedHTML
        case .CLP:
            return "&#36;".strippedHTML
        case .CNY:
            return "&yen;".strippedHTML
        case .COP:
            return "&#36;".strippedHTML
        case .CRC:
            return "&#x20a1;".strippedHTML
        case .CUC:
            return "&#36;".strippedHTML
        case .CUP:
            return "&#36;".strippedHTML
        case .CVE:
            return "&#36;".strippedHTML
        case .CZK:
            return "&#75;&#269;".strippedHTML
        case .DJF:
            return "Fr".strippedHTML
        case .DKK:
            return "DKK".strippedHTML
        case .DOP:
            return "RD&#36;".strippedHTML
        case .DZD:
            return "&#x62f;.&#x62c;".strippedHTML
        case .EGP:
            return "EGP".strippedHTML
        case .ERN:
            return "Nfk".strippedHTML
        case .ETB:
            return "Br".strippedHTML
        case .EUR:
            return "&euro;".strippedHTML
        case .FJD:
            return "&#36;".strippedHTML
        case .FKP:
            return "&pound;".strippedHTML
        case .GBP:
            return "&pound;".strippedHTML
        case .GEL:
            return "&#x10da;".strippedHTML
        case .GGP:
            return "&pound;".strippedHTML
        case .GHS:
            return "&#x20b5;".strippedHTML
        case .GIP:
            return "&pound;".strippedHTML
        case .GMD:
            return "D".strippedHTML
        case .GNF:
            return "Fr".strippedHTML
        case .GTQ:
            return "Q".strippedHTML
        case .GYD:
            return "&#36;".strippedHTML
        case .HKD:
            return "&#36;".strippedHTML
        case .HNL:
            return "L".strippedHTML
        case .HRK:
            return "Kn".strippedHTML
        case .HTG:
            return "G".strippedHTML
        case .HUF:
            return "&#70;&#116;".strippedHTML
        case .IDR:
            return "Rp".strippedHTML
        case .ILS:
            return "&#8362;".strippedHTML
        case .IMP:
            return "&pound;".strippedHTML
        case .INR:
            return "&#8377;".strippedHTML
        case .IQD:
            return "&#x639;.&#x62f;".strippedHTML
        case .IRR:
            return "&#xfdfc;".strippedHTML
        case .IRT:
            return "&#x062A;&#x0648;&#x0645;&#x0627;&#x0646;".strippedHTML
        case .ISK:
            return "kr.".strippedHTML
        case .JEP:
            return "&pound;".strippedHTML
        case .JMD:
            return "&#36;".strippedHTML
        case .JOD:
            return "&#x62f;.&#x627;".strippedHTML
        case .JPY:
            return "&yen;".strippedHTML
        case .KES:
            return "KSh".strippedHTML
        case .KGS:
            return "&#x441;&#x43e;&#x43c;".strippedHTML
        case .KHR:
            return "&#x17db;".strippedHTML
        case .KMF:
            return "Fr".strippedHTML
        case .KPW:
            return "&#x20a9;".strippedHTML
        case .KRW:
            return "&#8361;".strippedHTML
        case .KWD:
            return "&#x62f;.&#x643;".strippedHTML
        case .KYD:
            return "&#36;".strippedHTML
        case .KZT:
            return "KZT".strippedHTML
        case .LAK:
            return "&#8365;".strippedHTML
        case .LBP:
            return "&#x644;.&#x644;".strippedHTML
        case .LKR:
            return "&#xdbb;&#xdd4;".strippedHTML
        case .LRD:
            return "&#36;".strippedHTML
        case .LSL:
            return "L".strippedHTML
        case .LYD:
            return "&#x644;.&#x62f;".strippedHTML
        case .MAD:
            return "&#x62f;.&#x645;.".strippedHTML
        case .MDL:
            return "MDL".strippedHTML
        case .MGA:
            return "Ar".strippedHTML
        case .MKD:
            return "&#x434;&#x435;&#x43d;".strippedHTML
        case .MMK:
            return "Ks".strippedHTML
        case .MNT:
            return "&#x20ae;".strippedHTML
        case .MOP:
            return "P".strippedHTML
        case .MRO:
            return "UM".strippedHTML
        case .MUR:
            return "&#x20a8;".strippedHTML
        case .MVR:
            return ".&#x783;".strippedHTML
        case .MWK:
            return "MK".strippedHTML
        case .MXN:
            return "&#36;".strippedHTML
        case .MYR:
            return "&#82;&#77;".strippedHTML
        case .MZN:
            return "MT".strippedHTML
        case .NAD:
            return "&#36;".strippedHTML
        case .NGN:
            return "&#8358;".strippedHTML
        case .NIO:
            return "C&#36;".strippedHTML
        case .NOK:
            return "&#107;&#114;".strippedHTML
        case .NPR:
            return "&#8360;".strippedHTML
        case .NZD:
            return "&#36;".strippedHTML
        case .OMR:
            return "&#x631;.&#x639;.".strippedHTML
        case .PAB:
            return "B/.".strippedHTML
        case .PEN:
            return "S/.".strippedHTML
        case .PGK:
            return "K".strippedHTML
        case .PHP:
            return "&#8369;".strippedHTML
        case .PKR:
            return "&#8360;".strippedHTML
        case .PLN:
            return "&#122;&#322;".strippedHTML
        case .PRB:
            return "&#x440;.".strippedHTML
        case .PYG:
            return "&#8370;".strippedHTML
        case .QAR:
            return "&#x631;.&#x642;".strippedHTML
        case .RMB:
            return "&yen;".strippedHTML
        case .RON:
            return "lei".strippedHTML
        case .RSD:
            return "&#x434;&#x438;&#x43d;.".strippedHTML
        case .RUB:
            return "&#8381;".strippedHTML
        case .RWF:
            return "Fr".strippedHTML
        case .SAR:
            return "&#x631;.&#x633;".strippedHTML
        case .SBD:
            return "&#36;".strippedHTML
        case .SCR:
            return "&#x20a8;".strippedHTML
        case .SDG:
            return "&#x62c;.&#x633;.".strippedHTML
        case .SEK:
            return "&#107;&#114;".strippedHTML
        case .SGD:
            return "&#36;".strippedHTML
        case .SHP:
            return "&pound;".strippedHTML
        case .SLL:
            return "Le".strippedHTML
        case .SOS:
            return "Sh".strippedHTML
        case .SRD:
            return "&#36;".strippedHTML
        case .SSP:
            return "&pound;".strippedHTML
        case .STD:
            return "Db".strippedHTML
        case .SYP:
            return "&#x644;.&#x633;".strippedHTML
        case .SZL:
            return "L".strippedHTML
        case .THB:
            return "&#3647;".strippedHTML
        case .TJS:
            return "&#x405;&#x41c;".strippedHTML
        case .TMT:
            return "m".strippedHTML
        case .TND:
            return "&#x62f;.&#x62a;".strippedHTML
        case .TOP:
            return "T&#36;".strippedHTML
        case .TRY:
            return "&#8378;".strippedHTML
        case .TTD:
            return "&#36;".strippedHTML
        case .TWD:
            return "&#78;&#84;&#36;".strippedHTML
        case .TZS:
            return "Sh".strippedHTML
        case .UAH:
            return "&#8372;".strippedHTML
        case .UGX:
            return "UGX".strippedHTML
        case .USD:
            return "&#36;".strippedHTML
        case .UYU:
            return "&#36;".strippedHTML
        case .UZS:
            return "UZS".strippedHTML
        case .VEF:
            return "Bs F".strippedHTML
        case .VND:
            return "&#8363;".strippedHTML
        case .VUV:
            return "Vt".strippedHTML
        case .WST:
            return "T".strippedHTML
        case .XAF:
            return "CFA".strippedHTML
        case .XCD:
            return "&#36;".strippedHTML
        case .XOF:
            return "CFA".strippedHTML
        case .XPF:
            return "Fr".strippedHTML
        case .YER:
            return "&#xfdfc;".strippedHTML
        case .ZAR:
            return "&#82;".strippedHTML
        case .ZMW:
            return "ZK".strippedHTML
        }
    }


    // MARK: - Initializers & Methods

    /// Designated Initializer:
    /// Used primarily for testing and by the convenience initializers.
    ///
    init(currencyCode: CurrencyCode, currencyPosition: CurrencyPosition, thousandSeparator: String, decimalSeparator: String, numberOfDecimals: Int) {
        self.currencyCode = currencyCode
        self.currencyPosition = currencyPosition
        self.thousandSeparator = thousandSeparator
        self.decimalSeparator = decimalSeparator
        self.numberOfDecimals = numberOfDecimals
    }


    /// Convenience Initializer:
    /// Provides sane defaults for when site settings aren't available
    ///
    convenience init() {
        self.init(currencyCode: CurrencySettings.Default.code,
                  currencyPosition: CurrencySettings.Default.position,
                  thousandSeparator: CurrencySettings.Default.thousandSeparator,
                  decimalSeparator: CurrencySettings.Default.decimalSeparator,
                  numberOfDecimals: CurrencySettings.Default.decimalPosition)
    }

    /// Convenience Initializer:
    /// This is the preferred way to create an instance with the settings coming from the site.
    ///
    convenience init(siteSettings: [SiteSetting]) {
        self.init()

        siteSettings.forEach { updateCurrencyOptions(with: $0) }
    }

    func beginListeningToSiteSettingsUpdates() {
        try? resultsController.performFetch()
    }

    func updateCurrencyOptions(with siteSetting: SiteSetting) {
        let value = siteSetting.value

        switch siteSetting.settingID {
        case Constants.currencyCodeKey:
            let currencyCode = CurrencyCode(rawValue: value) ?? CurrencySettings.Default.code
            self.currencyCode = currencyCode
        case Constants.currencyPositionKey:
            let currencyPosition = CurrencyPosition(rawValue: value) ?? CurrencySettings.Default.position
            self.currencyPosition = currencyPosition
        case Constants.thousandSeparatorKey:
            self.thousandSeparator = value
        case Constants.decimalSeparatorKey:
            self.decimalSeparator = value
        case Constants.numberOfDecimalsKey:
            let numberOfDecimals = Int(value) ?? CurrencySettings.Default.decimalPosition
            self.numberOfDecimals = numberOfDecimals
        default:
            break
        }
    }
}


// MARK: -

private extension CurrencySettings {
    enum Constants {
        static let currencyCodeKey = "woocommerce_currency"
        static let currencyPositionKey = "woocommerce_currency_pos"
        static let thousandSeparatorKey = "woocommerce_price_thousand_sep"
        static let decimalSeparatorKey = "woocommerce_price_decimal_sep"
        static let numberOfDecimalsKey = "woocommerce_price_num_decimals"
    }
}
