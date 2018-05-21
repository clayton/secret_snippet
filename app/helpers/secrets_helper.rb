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

  def expires_at_options
    options_for_select(
      [
        ['1 Hour', (Time.now + 1.hour)], ['1 Day', (Time.now + 1.day)], ['1 Week', (Time.now + 1.week)]
      ],
      (Time.now + 1.day)
    )
  end
end
