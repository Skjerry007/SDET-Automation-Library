package com.gromo.qa.motor.insurance.postrequest;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;

public class RunnerTest {
	
	
	@Test
	public Karate runTest() {
		return Karate.run("createLeadDataDriven").relativeTo(getClass());
	}
}
