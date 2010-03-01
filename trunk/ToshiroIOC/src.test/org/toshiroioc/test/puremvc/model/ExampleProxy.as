package org.toshiroioc.test.puremvc.model
{
	
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ExampleProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'ExampleProxy';
		
		private var name_arr:Array = ["simon", "bailey"]
		
		public function ExampleProxy()
		{
			super( NAME, new ArrayCollection );
		}
		
		public function get my_arr():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		override public function onRegister():void
		{			
			data = buildNameObjectArray();
		}
		
		protected function buildNameObjectArray():ArrayCollection
		{
			var s:String;
			var e_vo:ExampleVO;
			var ac:ArrayCollection = new ArrayCollection();
			
			for each ( s in name_arr )
			{
				e_vo = new ExampleVO();
				e_vo.label = s;
				ac.addItem( e_vo );
			}
			return ac;
		}
	}
}