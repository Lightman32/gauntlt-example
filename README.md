Please checkout the [original gauntlt repo](https://github.com/gauntlt/gauntlt) for more information. 

# Gauntlt

Gauntlt is one of the most commonly used frameworks for automated security testing. Under the hood, it integrates with most frequently used tools for security such as **arachni, nmap, sqlmap, dirb** and **garmar**. Gauntlt is built on the cucumber framework which provides users ability to write their own test in an easy to understand natural language format, Gauntlt allows us to run a range of attacks using these tools and parse the output in a friendly manner.

### Attack files

To run gauntlt we need attack files which are nothing more than a plain text file written in a Gherkin syntax ending with extension .attack. Gauntlt attack files are very similar to cucumber feature files with one main difference that gauntlt provides us with predefined steps so we won't have to write our own step definitions.

Writing attack file is simple and gauntlt provides us with some pre-build attack files, let's look at one of them to see how we can write our own attack files

```
Feature: Run sslyze against a target

Background:
  Given "sslyze" is installed
  And the following environment variables:
    | name     | environment_variable_name      |
    | hostname | TEST_HOSTNAME |

Scenario: Ensure no SSLv2 and SSLv3 are disabled
  When I launch an "sslyze" attack with:
    """
    python <sslyze_path> --sslv2 --sslv3 <hostname>:443
    """
  Then the output should not contain:
    """
   Accepted
    """
```

Since Gherkin uses natural language it's easier to understand and write them. Each file has 3 main sections

**Feature** - Provides a description of attack

**Background** - This section is used to ensure some prerequisite has met before running the attack, in most cases, it used to check is the correct tools and target information is available before proceeding with the attack. In the above example, we are confirming that ssylze is installed and available to the gauntlt. We are also pulling in some value from environment variables.

**Scenario** - Here we outline the commands that will be used to run the underlying tool and expected output to match from that. In our example, we are running sslyze on <hostname> ( a reference to data set in the background section) to check if SSL v2 and V3 are enabled. After running the command gauntlt will parse the output to ensure "Accepted" is not included in the output else it will mark the test failed. Each attack file can have multiple scenarios but its generally good practice to keep the test cases separate or have a very small number of them in one file.

### Tools Overview

As discussed previously gauntlt under the hood is just a wrapper around existing security tools, some of these tools and their usage in our setup is given below.

**nmap** - Nmap is used to ensure that only required ports are open and sensitive ports such as database are not open to the public, nmap can be expanded to use various other scripts for checking specific vulnerabilities.

**dirb** - dirb is used to check exposed URL's of the application to ensure hidden directories are not open to the public.

**arachni** - Arachni can be used for the variety of attack mainly related to web applications. In our case, we are using it check for **XSS, SQL, insecure cookies, form-upload, HTTP methods** and **os injection** vulnerabilities.

**sqlmap** - Used for testing SQL injection primarily on login pages.

**sslyze** - For resting SSL implementation.
