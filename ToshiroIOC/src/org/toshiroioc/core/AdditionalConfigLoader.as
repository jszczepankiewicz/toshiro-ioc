package org.toshiroioc.core
{

	public class AdditionalConfigLoader
	{
		private var _configs:Vector.<XML> = new Vector.<XML>;
		
		public function AdditionalConfigLoader(configs:Array)
		{
			for each(var xmlString:String in configs){
				this.configs.push(constructXMLFromEmbed(xmlString));
			}
		}
		
		private function constructXMLFromEmbed(xmlString:String):XML{		
			return new XML(xmlString);
		}

		public function get configs():Vector.<XML>
		{
			return _configs;
		}

		public function set configs(value:Vector.<XML>):void
		{
			_configs = value;
		}

	}
}