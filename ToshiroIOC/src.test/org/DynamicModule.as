package org
{
	import mx.containers.Panel;

	public class DynamicModule extends Panel
	{
		public var onConstruct:Boolean;
		
		public function DynamicModule()
		{
			super();
			onConstruct = true;
		}
		
	}
}