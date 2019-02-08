set STATUS (systemctl status nftables | grep inactive)
if test "$STATUS" != ""
        echo "  "
end
