module GitFit
  class GitLib

    def get_commit_author(commit_sha)
      `git show -s --format=%an #{commit_sha}`.strip
    end

    def get_commit_date(commit_sha)
      `git show -s --format=%at #{commit_sha}`.strip.to_i
    end

    def get_largest_files(number=10)
      `git ls-files -z | xargs -0 ls -l | sort -nrk5 | head -n #{number}`
    end

    def get_object_sha_from_path(path)
      `git ls-files -s #{path} | cut -d ' ' -f 2`
    end

    def get_revision_list(treeish='HEAD')
      `git rev-list #{treeish}`
    end

    def get_treeish_contents(treeish)
      `git ls-tree -zrl #{treeish}`
    end

    def get_file_list(treeish)
      `git ls-tree -r --name-only #{treeish}`.split "\n" # could use ls-files but treeishes not supported
    end

    def get_commit_count_for_branch(branch)
      `git rev-list --branches origin/#{branch} | wc -l`.strip
    end

  end
end