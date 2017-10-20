#!/bin/bash
# Add support for registering host on dns server. Must allow non-secure updates

set -e

DOMAINNAME=$1

echo $(date) " - Starting Script"

cat > /etc/dhcp/dhclient-exit-hooks.d/register-dns <<EOFDHCP
#!/bin/sh

# only execute on the primary nic
if [ "\$interface" != "eth0" ]
then
    return
fi

# when we have a new IP, perform nsupdate
if [ "\$reason" = BOUND ] || [ "\$reason" = RENEW ] ||
    [ "\$reason" = REBIND ] || [ "\$reason" = REBOOT ]
then
    host=\$(hostname -s)
    nsupdatecmds=/var/tmp/nsupdatecmds
    echo "update delete \$host.${DOMAINNAME} a" > \$nsupdatecmds
    echo "update add \$host.${DOMAINNAME} 3600 a \$new_ip_address" >> \$nsupdatecmds
    echo "send" >> \$nsupdatecmds

    sleep 10
    nsupdate \$nsupdatecmds
fi
EOFDHCP

chmod 755 /etc/dhcp/dhclient-exit-hooks.d/register-dns

if ! grep -Fq "$(DOMAINNAME)" /etc/dhcp/dhclient.conf
then
    echo $(date) " - Adding domain to dhclient.conf"

    echo "supersede domain-name \"$(DOMAINNAME)\";" >> /etc/dhcp/dhclient.conf
    echo "prepend domain-search \"$(DOMAINNAME)\";" >> /etc/dhcp/dhclient.conf
fi

# service networking restart
echo $(date) " - Restarting network"
/etc/init.d/networking restart
