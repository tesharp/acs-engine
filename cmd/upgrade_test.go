package cmd

import (
	"testing"
)

func TestUpgradeValidateCmd(t *testing.T) {

	v := upgradeCmd{
		resourceGroupName: "TestGroup",
		upgradeModelFile:  "../pkg/acsengine/testdata/simple/kubernetes.json",
	}
	r := NewRootCmd()

	err := v.validate(r, []string{})
	if err != nil {
		t.Fatalf("unexpected error validating upgrade cmd: %s", err.Error())
	}
}
