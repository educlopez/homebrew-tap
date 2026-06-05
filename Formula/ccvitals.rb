class Ccvitals < Formula
  desc "Pretty, pure-bash statusline for Claude Code — quota, context, cost, git & more"
  homepage "https://github.com/educlopez/ccvitals"
  url "https://github.com/educlopez/ccvitals/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "a383d72c08d7c8293e1663346efc4be0ff6477342fea358108fc6519b2cbf6c5"
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
