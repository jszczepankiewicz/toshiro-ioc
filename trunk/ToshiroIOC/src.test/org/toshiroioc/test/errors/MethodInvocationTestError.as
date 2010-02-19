package org.toshiroioc.test.errors
{
	class MethodInvocationTestError extends Error 
	{
		//public static const METHOD_INVOCATED : int = 1;
		private const TEST_ERROR_MSG : String = "testError";  
		public var invocatedMethodName : String;
	    
	    public function MethodInvocationTestError(methodName:String) 
	    {
	        super(TEST_ERROR_MSG);
	        invocatedMethodName = methodName;
	    }
	}
}