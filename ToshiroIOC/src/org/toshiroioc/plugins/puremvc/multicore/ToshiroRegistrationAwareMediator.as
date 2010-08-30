package org.toshiroioc.plugins.puremvc.multicore
{
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ToshiroRegistrationAwareMediator extends Mediator implements IRegistrationAware
	{
		private var _register:Boolean = false;
		
		public function ToshiroRegistrationAwareMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		public function get register():Boolean
		{
			return _register;
		}

		public function set register(value:Boolean):void
		{
			_register = value;
		}

	}
}