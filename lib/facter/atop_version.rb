Facter.add(:atop_version) do
  confine :kernel => :linux
  setcode do
    if File.exists? "/bin/atop"
      Facter::Util::Resolution.exec('atop -V |  awk \'/Version: / { print $2 }\'')
    else
      nil
    end
  end
end
