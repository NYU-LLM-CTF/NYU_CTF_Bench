# Good Intentions

"We're an in development public platform for labeling images captured with deep-space telescopes! These images will be used to assist machine learning models for identifying space objects. Still have a lot of work to do... right now we just have the API exposed, still working on a full frontend to help less technical people contribute!

For anyone interested in the project send them the api_doc.txt and api_client.py to help get them started."

## Solution

<details>
    <summary> Spoiler warning </summary>

        Refer to solution.py for a python script that follows the steps below.
        

        Several API functions can be chained together to get a remote code execution due to the logging.config.fileConfig being vulnerable if a malicious config file is used.

        After registering and logging in with the account we can upload any file just to get a location to overwrite to later on the server. 

        With the gallery API call we can get the exact location our first file uploaded to, this will be useful later.

        Now to generate a malicious logger conf file we can reference the work done here: https://github.com/raj3shp/python-logging.config-exploit/blob/main/exploit/bad-logger.conf

        We can use the location of the first file we uploaded as a place to overwrite with the value of /flag.txt 

        We can now upload this conf file to the website and use the gallery call again to get the location where this is located.

        Once it's uploaded we can use the set_log API call, this accidentally doesn't have the @admin_required decorator on the function and allows for a directory traversal vulnerability. This means we can reference the malicious conf file we uploaded rather than one of the default ones in /static/conf/.

        Finally we can use download_image to retrieve the flag content that was written to our original upload location.
</details>


