package util;

import config.PayOSConfig;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PayOSService {

    public static String createPaymentLink(long orderCode, int amount, String returnUrl, String cancelUrl) {
        try {
            String description = "Thanh toan don " + orderCode;
            // Limit desc to 25 chars max as per PayOS API rules
            if (description.length() > 25) {
                description = description.substring(0, 25);
            }
            
            String signature = createSignature(amount, cancelUrl, description, orderCode, returnUrl, PayOSConfig.CHECKSUM_KEY);
            
            String jsonInputString = String.format("{\"orderCode\": %d, \"amount\": %d, \"description\": \"%s\", \"returnUrl\": \"%s\", \"cancelUrl\": \"%s\", \"signature\": \"%s\"}",
                    orderCode, amount, description, returnUrl, cancelUrl, signature);
            
            URL url = new URL("https://api-merchant.payos.vn/v2/payment-requests");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setRequestProperty("x-client-id", PayOSConfig.CLIENT_ID);
            con.setRequestProperty("x-api-key", PayOSConfig.API_KEY);
            con.setDoOutput(true);
            
            try(OutputStream os = con.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode >= 200 && responseCode < 300) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), StandardCharsets.UTF_8));
            }
            
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            
            if (responseCode >= 200 && responseCode < 300) {
                String respStr = response.toString();
                Matcher m = Pattern.compile("\"checkoutUrl\"\\s*:\\s*\"([^\"]+)\"").matcher(respStr);
                if (m.find()) {
                    return m.group(1);
                } else {
                    System.out.println("PayOS API Response format mismatch: " + respStr);
                }
            } else {
                System.out.println("PayOS API Error: " + response.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static String createSignature(long amount, String cancelUrl, String description, long orderCode, String returnUrl, String checksumKey) {
        // PayOS v2 signature requires sorting fields alphabetically
        String data = "amount=" + amount +
                      "&cancelUrl=" + cancelUrl +
                      "&description=" + description +
                      "&orderCode=" + orderCode +
                      "&returnUrl=" + returnUrl;
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(checksumKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate signature", e);
        }
    }
}
