class TMate
  def self.create_detached_session
    # detached tmate sessions require tmate 1.8.10
    `tmate -S /tmp/tmate.sock new-session -d`
    `tmate -S /tmp/tmate.sock wait tmate-ready`
  end

  def self.address(options="")
    address = `tmate #{options} display -p '\#{tmate_ssh}' 2>/dev/null`
    address.split[1]
  end

  def self.detached_address
    self.address('-S /tmp/tmate.sock')
  end

  def self.my_session_address
    self.address
  end
end
