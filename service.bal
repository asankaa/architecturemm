import ballerinax/github;
import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
#
configurable string tokenName = ?;

service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - string name with hello message or error
    resource function get greeting() returns string[]|error {
        // Send a response back to the caller.--
        github:Client githubEp = check new (config = {
            auth: {
                token: tokenName

            }
        });

        stream<github:Repository, error?> getRepositoriesResponse = check githubEp->getRepositories();
        string[]? repos = check from var rec in getRepositoriesResponse
            select rec.name;
        return repos ?: [];
    }

}
