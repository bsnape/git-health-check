module GitFit
  class GitLib

    def get_commit_author(commit)
      `git show -s --format=%an #{commit}`.strip
    end

    def get_commit_date(commit)
      `git show -s --format=%at #{commit}`.strip.to_i
    end

    def calculate_file_sizes
      file_sizes = {}
      get_file_list.each do |filepath|
        file_sizes.merge!({ get_file_size(filepath) => filepath })
      end
      file_sizes
    end

    def get_file_size(path)
      `wc -c #{path} | awk '{print $1}'`.strip.to_i
    end

    def get_object_sha_from_path(path)
      `git ls-files -s #{path} | cut -d ' ' -f 2`
    end

    def get_revision_list(commit)
      `git rev-list #{commit}`.split("\n")
    end

    def get_commit_contents(treeish)
      contents       = `git ls-tree -zrl #{treeish}`.split("\0")
      split_contents = contents.map { |c| c.split(' ') }
      split_contents.map do |bits, type, sha, size, path|
        {
          :bits => bits.to_i,
          :type => type,
          :sha  => sha,
          :size => size.to_i,
          :path => path
        }
      end
    end

    def get_file_list
      `git ls-files -z`.split("\u0000")
    end

    def get_commit_count_for_branch(branch)
      `git rev-list --branches #{branch} | wc -l`.strip.to_i
    end

    def get_all_blobs
      output = {}

      get_revision_list('HEAD').each do |commit|
        get_commit_contents(commit).each do |commit_contents|
          if commit_contents.fetch(:type) == 'blob'
            output.merge!(commit_contents.fetch(:path) => commit_contents.fetch(:size))
          end
        end
      end

      output
    end

  end
end
