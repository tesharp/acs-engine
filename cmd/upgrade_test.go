package cmd

import (
	"testing"
)

func TestUpgradeValidateCmd(t *testing.T) {

	// deployCmd := &deployCmd{
	// 	apimodelPath:    "./this/is/unused.json",
	// 	dnsPrefix:       "dnsPrefix1",
	// 	outputDirectory: "_test_output",
	// 	location:        "westus",

	// 	client: &armhelpers.MockACSEngineClient{},
	// }

	//autofillApimodel(deployCmd)

	v := upgradeCmd{
		resourceGroupName:   "TestGroup",
		upgradeModelFile:    "../pkg/acsengine/testdata/simple/kubernetes.json",
		deploymentDirectory: "_test_output",
	}
	v.authArgs.RawAzureEnvironment = "AzurePublicCloud"
	v.authArgs.AuthMethod = "device"
	v.authArgs.rawSubscriptionID = "testID"

	r := NewRootCmd()

	err := v.validate(r, []string{})
	if err != nil {
		t.Fatalf("unexpected error validating upgrade cmd: %s", err.Error())
	}
}
