#!/bin/bash -eu

echo ''
echo ''
echo '    #                              #     # #     #  #####  '
echo '    #       # #####  #####  ###### ##    # ##   ## #     # '
echo '    #       # #    # #    # #      # #   # # # # # #       '
echo '    #       # #####  #    # #####  #  #  # #  #  #  #####  '
echo '    #       # #    # #####  #      #   # # #     #       # '
echo '    #       # #    # #   #  #      #    ## #     # #     # '
echo '    ####### # #####  #    # ###### #     # #     #  #####  '
echo ''
echo ''
echo '    #> Configuring container...'
ansible-playbook -i 'localhost ansible_connection=local,' /docker/entrypoint.playbook.yml -vv
echo ''
echo ''
echo '    #> Verifying librenms install...'
/opt/librenms/validate.php
echo ''
echo ''
echo '    #> Starting supervisord...'
supervisord -n -c /etc/supervisor/supervisord.conf

