# Install gpg on Ubuntu with below command
sudo apt-get install gnupg
</br>
</br>
</br>

# To check any existing key in system
gpg --list-keys
</br>
</br>
</br>

# Generate new keys
gpg --full-generate-key

1. Select the Key type
2. Select the bit size
3. Enter expiry period
4. Enter the "real name" as its in Github account
5. Enter verified email id assocaited with the account
6. After final submission it will ask for Passphrase. This passphrase will be used during commit
</br>
</br>
</br>

# Updating Passphrase
gpg -passwd abc@email.com
</br>
</br>
</br>

# Command to list Public keys
gpg --list-secret-keys --keyid-format LONG
</br>
</br>
</br>

# Exporting Public Key
Copy paste the public key from above output into github under GPG section for new key. This will give you a new Key ID

Copy the newly created Key ID to export as shown below

gpg --armor --export 530650148D937CE2

You can also obtain the public key as below from the command line

gpg --export --armor --output gpg_public_key.asc abc@email.com
</br>
</br>
</br>

# Configure git global properties as below
git config --list
git config --global user.signingkey 530650148D937CE2 
git config --global commit.gpgsign true
git config --global tag.gpgsign true
which gpg
git config --global gpg.program /usr/bin/gpg
</br>
</br>
</br>

Once above configuration is completed, everytime a new commit is done it will be encrypted,
during the commit process, enter the passphrase set during key generation.
