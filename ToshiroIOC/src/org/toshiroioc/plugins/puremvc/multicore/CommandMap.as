package org.toshiroioc.plugins.puremvc.multicore
{
	/**
	 * 
	 * @author M.Strecker
	 * 
	 */	
	public class CommandMap
	{
		private var notificationField : String;
		private var commandField : Class;
		
		public function CommandMap()
		{
		}
		
		public function set notification(value : String) : void
		{
			notificationField = value;
		}
		
		public function get notification() : String
		{
			return notificationField;
		}
		
		public function set command(value : Class) : void
		{
			commandField = value;
		}
		
		public function get command() : Class
		{
			return commandField;
		}
	
	}
}