package org.toshiroioc.test.puremvc.model
{
	
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class DynamicExampleProxy2 extends Proxy implements IProxy
	{
		public static const NAME:String = 'DynamicExampleProxy2';
		
		public function DynamicExampleProxy2()
		{
			super( NAME);
		}
		
		override public function onRegister():void
		{			
			
		}
	}
}