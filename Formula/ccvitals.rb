class Ccvitals < Formula
  desc "Pretty, pure-bash statusline for Claude Code — quota, context, cost, git & more"
  homepage "https://github.com/educlopez/ccvitals"
  url "https://github.com/educlopez/ccvitals/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "15d3d6cec8424b3b8370acdf4d95b81d8979f21d464db946662dd0fc7648f5a1"
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
