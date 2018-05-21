module SecretsHelper
  def random_funny_email_address
    %w[
      george.washington@usa.gov
      monster@cook.ie
      moe@moestavern.us
      ferris@saveferris.org
      dracula@redcross.org
      bugs@carrots.co
      fred@yabbadabba.do
      alvin@thechimpmunks.net
      hank@striklandpropane.us
      homer.simpson@springfieldnuclear.com
      wile.e.coyote@acme.com
      bob@squarepants.net
      george.jetson@spacelys.sprockets
    ].shuffle.first
  end
end
