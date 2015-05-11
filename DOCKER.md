## Maslow steps

1. Create the database, otherwise - when loading the app in a browser - you will see this error:

![error no database](https://raw.githubusercontent.com/crossgovernmentservices/dev-env/master/doc/error-no-db.png)

    ./docker.sh run maslow db:setup

2. If you wish to create a user account for testing, run this command, replacing the name etc with your details:


    ```
    ./docker.sh run maslow bin/rake users\:create_first_user\["juan","email@example.org","yoursuperrandompassphrase"\]
    ```

## Maslow testing

1. Prepare the Maslow test database:

    ```
    ./docker.sh run maslow bin/rake db:test:prepare
    ```

2. Run the tests


    ```
    ./docker.sh run maslow bin/rake spec
 
