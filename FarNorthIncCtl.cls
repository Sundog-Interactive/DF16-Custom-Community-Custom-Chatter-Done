/**
 * Created by joe.mcnett on 9/15/2016.
 */

public with sharing class FarNorthIncCtl {

    public static String communityId {get; set;}

    public FarNorthIncCtl() {
        communityId = Network.getNetworkId();
    }
    
    public static String getBaseUrl() {
        return Site.getBaseUrl();
    }
}