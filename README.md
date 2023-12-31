ansible -i hostfile all -m user -a "name=admin update_password=always password={{ newpassword|password_hash('sha512') }}" -b --extra-vars "newpassword=12345678"
