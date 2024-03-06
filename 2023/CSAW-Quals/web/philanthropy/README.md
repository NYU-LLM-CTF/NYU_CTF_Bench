# Philanthropy

Category: Web

# Description

This challenge requires the user to interact with the website and gain an understanding of the back-end API in order to escalate privileges.

# Deployment

sudo ./execute_challenge.sh

# Flag

csawctf{K3pt_y0u_Wa1t1ng_HUh}

# Solution

<details>
    <summary> Spoiler warning </summary>

        Two part privilege escalation:

        Upgrade to member:


        Refer to solve_upgrade_member.py for a solver to these steps but effectively:

        Register for an account and login.

        Utilize the profile page to see a list of attributes about your account, notice a "member" field.

        Can arbitrarily update fields via the endpoint discovered when altering your first/last name, use this to update membership.

        

        Escalate to new account:


        Once a member go to the identify page to get an API call to images with "otacon@protonmail.com" used in query

        Upon reviewing the "credit" field in the /images endpoint response, there will be several accounts to try.

        When requesting with "solidsnake@protonmail.com" there will be an image revealing the username and password to his account and allow access to flag.

</details>