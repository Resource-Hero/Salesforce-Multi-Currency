public class CurrencyUtilities {
    public static Decimal CurrencyConvert(Map<String, CurrencyType> currencymap, String isoCode, Decimal valuetoconvert) {
        return valuetoconvert / currencymap.get(isoCode).ConversionRate;
    }
}