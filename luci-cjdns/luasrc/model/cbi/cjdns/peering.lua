uci = require "luci.model.uci"
cursor = uci:cursor_state()

m = Map("cjdns", translate("cjdns"),
  translate("Implements an encrypted IPv6 network using public-key \
    cryptography for address allocation and a distributed hash table for \
    routing. This provides near-zero-configuration networking, and prevents \
    many of the security and scalability issues that plague existing \
    networks."))

m.on_after_commit = function(self)
end

-- UDP Peers
udp_peers = m:section(TypedSection, "udp_peer", translate("Outgoing UDP Peers"),
  translate("First find the cjdns ip of your upstream node. \
    (Ask him/her if you can't find out) This is the \
    node you got connection credentials from."))
udp_peers.anonymous = true
udp_peers.addremove = true
udp_peers.template  = "cbi/tblsection"

udp_peers:option(Value, "address", translate("IP Address")).datatype = "ip4addr"
udp_peers:option(Value, "port", translate("Port")).datatype = "port"
udp_interface = udp_peers:option(Value, "interface", translate("UDP Interface"))
local index = 1
for i,section in pairs(cursor:get_all("cjdns")) do
  if section[".type"] == "udp_interface" then
    udp_interface:value(index, section.address .. ":" .. section.port)
  end
end
udp_peers:option(Value, "public_key", translate("Public Key"))
udp_peers:option(Value, "password", translate("Password"))

-- Ethernet Peers
eth_peers = m:section(TypedSection, "eth_peer", translate("Outgoing Ethernet Peers"),
  translate("Connect to other cjdns nodes on the same LAN."))
eth_peers.anonymous = true
eth_peers.addremove = true
eth_peers.template  = "cbi/tblsection"

eth_peers:option(Value, "address", translate("MAC Address")).datatype = "macaddr"
eth_interface = eth_peers:option(Value, "interface", translate("Ethernet Interface"))
local index = 1
for i,section in pairs(cursor:get_all("cjdns")) do
  if section[".type"] == "eth_interface" then
    eth_interface:value(index, section.bind)
  end
end
eth_peers:option(Value, "public_key", translate("Public Key"))
eth_peers:option(Value, "password", translate("Password"))

-- Authorized Passwords
passwords = m:section(TypedSection, "password", translate("Authorized Passwords"),
  translate("Anyone offering these passwords on connection will be allowed."))
passwords.anonymous = true
passwords.addremove = true
passwords.template  = "cbi/tblsection"

function generate_password()
-- tr -cd 'A-Za-z0-9' < /dev/urandom
  local process = io.popen("tr -cd 'A-Za-z0-9' < /dev/urandom", "r")
  local password = process:read(32)
  process:close()
  return password
end

passwords:option(Value, "user", translate("User/Name (optional)"))
passwords:option(Value, "contact", translate("Contact (optional)"))
passwords:option(Value, "password", translate("Password")).default = generate_password()

return m
