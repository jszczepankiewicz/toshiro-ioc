package org.toshiroioc.test.puremvc.model
{
	
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class DynamicExampleProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'DynamicExampleProxy';
		
		public function DynamicExampleProxy()
		{
			super( NAME, new ArrayCollection );
		}
		
		override public function onRegister():void
		{			
		}
		
	}
}