import jenkins.model.Jenkins
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import hudson.util.Secret

def privateStageKey = System.getenv('VAGRANT_STAGE_KEY')
def privateProdKey = System.getenv('VAGRANT_PROD_KEY')

if (privateStageKey) {

    def jenkins = Jenkins.instance
    def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
    def domain = Domain.global()

    def existing = store.getCredentials(domain).find { it.id == 'petclinic-stage-vagrant-key' }
    if (existing) {
        store.removeCredentials(domain, existing)
        println "Removed existing credential"
    }

    def cred = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        'petclinic-stage-vagrant-key',
        'vagrant',
        new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateStageKey),
        '',
        'Vagrant SSH key for petclinic-stage'
    )

    store.addCredentials(domain, cred)
    println "Vagrant SSH key configured successfully for Stage"
} else {
    println "VAGRANT_STAGE_KEY environment variable not found, skipping Vagrant SSH config"
}


if (privateProdKey) {

    def jenkins = Jenkins.instance
    def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
    def domain = Domain.global()

    def existing = store.getCredentials(domain).find { it.id == 'petclinic-prod-vagrant-key' }
    if (existing) {
        store.removeCredentials(domain, existing)
        println "Removed existing credential"
    }

    def cred = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        'petclinic-prod-vagrant-key',
        'vagrant',
        new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateProdKey),
        '',
        'Vagrant SSH key for petclinic-prod'
    )

    store.addCredentials(domain, cred)
    println "Vagrant SSH key configured successfully for Prod"
} else {
    println "VAGRANT_PROD_KEY environment variable not found, skipping Vagrant SSH config"
}
