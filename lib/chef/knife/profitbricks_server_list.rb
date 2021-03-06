require 'chef/knife'
require 'chef/json_compat'

require_relative 'profitbricks_base'
class Chef
  class Knife
    class ProfitbricksServerList < Knife
      require_relative 'profitbricks_base'
      deps do
        require 'profitbricks'
        require 'highline'        
        Chef::Knife.load_deps
      end

      include Chef::Knife::ProfitbricksBase

      banner "knife profitbricks server list OPTIONS"

      option :datacenter_name,
        :short => "-d DATACENTER_NAME",
        :long => "--datacenter-name DATACENTER_NAME",
        :description => "The datacenter of which to list the servers",
        :proc => Proc.new { |datacenter| Chef::Config[:knife][:profitbricks_datacenter] = datacenter }

      def run
        configure
        datacenters = Profitbricks::DataCenter.all

        server_list = [
            ui.color('ID', :bold),
            ui.color('Name', :bold),
            ui.color('Datacenter', :bold),
            ui.color('CPUs', :bold),
            ui.color('RAM', :bold),
            ui.color('IPs', :bold)

        ]

        datacenters.each do |dc|
          dc.servers.each do |s|
            server_list << s.id
            server_list << s.name
            server_list << dc.name
            server_list << s.cores.to_s
            server_list << s.ram.to_s
            server_list << (s.respond_to?("ips") ? s.ips : "")
          end
        end

        puts ui.list(server_list, :uneven_columns_across, 6)
      end
    end
  end
end
