class Ccvitals < Formula
  desc "Pretty, pure-bash statusline for Claude Code — quota, context, cost, git & more"
  homepage "https://github.com/educlopez/ccvitals"
  url "https://github.com/educlopez/ccvitals/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  depends_on "jq"

  def install
    pkgshare.install "statusline.sh", "subagent-statusline.sh", "install.sh", "uninstall.sh"

    (bin/"ccvitals").write <<~EOS
      #!/bin/bash
      # ccvitals installer wrapper — runs the bundled installer against the
      # Homebrew-managed copy of statusline.sh.
      case "${1:-}" in
        uninstall) exec bash "#{opt_pkgshare}/uninstall.sh" "${@:2}" ;;
        *)         exec bash "#{opt_pkgshare}/install.sh" "$@" ;;
      esac
    EOS
  end

  def caveats
    <<~EOS
      Run the interactive installer to wire ccvitals into Claude Code:
        ccvitals

      Non-interactive:
        ccvitals --all

      After `brew upgrade ccvitals`, run `ccvitals --force` once to relink
      the new version. To remove it from Claude Code:
        ccvitals uninstall
    EOS
  end

  test do
    payload = '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/tmp"},' \
              '"context_window":{"context_window_size":200000}}'
    output = pipe_output("bash #{pkgshare}/statusline.sh", payload)
    assert_match "Test", output
  end
end
