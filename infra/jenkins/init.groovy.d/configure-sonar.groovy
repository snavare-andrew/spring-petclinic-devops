import jenkins.model.Jenkins
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl

def sonarToken = System.getenv('SONAR_TOKEN')
if (sonarToken) {
    println "Configuring SonarQube token from environment variable..."
    
    def credentialsStore = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
    def domain = Domain.global()
    
    def existingCred = credentialsStore.getCredentials(domain).find { it.id == 'sonar-token' }
    if (existingCred) {
        credentialsStore.removeCredentials(domain, existingCred)
        println "Removed existing sonar-token credential"
    }
    
    def newCred = new StringCredentialsImpl(
        CredentialsScope.GLOBAL,
        'sonar-token',
        'SonarQube token',
        hudson.util.Secret.fromString(sonarToken)
    )
    credentialsStore.addCredentials(domain, newCred)
    println "SonarQube token configured successfully"
} else {
    println "SONAR_TOKEN environment variable not found, skipping configuration"
}