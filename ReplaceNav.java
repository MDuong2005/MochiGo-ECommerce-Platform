import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ReplaceNav {
    public static void main(String[] args) throws Exception {
        File dir = new File("c:/Mochi/web/admin");
        File[] files = dir.listFiles((d, name) -> name.endsWith(".jsp") && !name.equals("admin-nav.jsp"));
        if (files != null) {
            String regex = "(?s)<nav class=\"bg-pink-800 text-white shadow-md\">.*?</nav>";
            Pattern pattern = Pattern.compile(regex);
            
            for (File file : files) {
                String content = new String(Files.readAllBytes(file.toPath()), "UTF-8");
                Matcher m = pattern.matcher(content);
                if (m.find()) {
                    String newContent = m.replaceAll("<jsp:include page=\"/admin/admin-nav.jsp\" />");
                    Files.write(file.toPath(), newContent.getBytes("UTF-8"));
                    System.out.println("Replaced nav in " + file.getName());
                }
            }
        }
    }
}
