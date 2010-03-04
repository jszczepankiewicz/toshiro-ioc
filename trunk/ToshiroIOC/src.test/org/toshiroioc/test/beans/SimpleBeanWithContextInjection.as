package org.toshiroioc.test.beans{
	import org.toshiroioc.core.XMLBeanFactory;
	

	
	public class SimpleBeanWithContextInjection{
				
		private var dependencyField:SimpleBean;
		private var dependencyField2:SimpleBean;
		private var numberField:Number;
		public var beforeConfigureMethodInvocation:Boolean;
		public var afterConfigureMethodInvocation:Boolean;
		private var contextField:XMLBeanFactory;
		
		
		[BeforeConfigure]
		public function methodBeforeConfigure():void{
			if (!numberField)
				beforeConfigureMethodInvocation = true;
		}
		
		[AfterConfigure]
		public function methodAfterConfigure():void{
			if (numberField)
				afterConfigureMethodInvocation = true;
		}
		
		[Required]
		public function set dependencyItem(value:SimpleBean):void{
			dependencyField = value;	
		}
		
		public function get dependencyItem():SimpleBean{
			return dependencyField;
		} 
		
		[Required]
		public function set dependencyItem2(value:SimpleBean):void{
			dependencyField2 = value;	
		}
		
		public function get dependencyItem2():SimpleBean{
			return dependencyField2;
		} 
		
		public function set numberItem(value:Number):void{
			numberField = value;
		}
		
		public function get numberItem():Number{
			return numberField;
		}
		
		[ToshiroIOCFactory]
		public function set context(value:XMLBeanFactory):void{
			contextField = value;
		}
		
		public function get context():XMLBeanFactory{
			return contextField;
		}
		
	}
}