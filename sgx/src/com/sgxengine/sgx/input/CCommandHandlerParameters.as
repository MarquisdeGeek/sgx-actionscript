package com.sgxengine.sgx.input
{
	import com.sgxengine.sgx.core.math.Numerics;
	import com.sgxengine.sgx.core.math.SGXMathUtils;

	public class CCommandHandlerParameters
	{
		public var axis : Number;
		
		// What portion of the stick are we considering?
		public var fRangeFrom : Number;
		public var fRangeTo : Number;
		
		// What range is fed back to the user
		public var fTargetScaleFrom : Number;
		public var fTargetScaleRangeTo : Number;

	
		public function CCommandHandlerParameters(commandControl : *, rangeFrom : Number, rangeTo : Number) {
//			this->pCommand = &CSGXInputManager::get()->getControlButton(CSGXInputManager::eFirst, commandControl);
			fRangeFrom = rangeFrom;
			fRangeTo = rangeTo;
			fTargetScaleFrom = 0;
			fTargetScaleRangeTo = 1.0;
		}
		
		
		public function prepareRange(value : Number) : Number {
			
			// check whether it's in the required range of the stick
			var newValue : Number = SGXMathUtils.sgxRange(value, fRangeFrom, fRangeTo);
			
			// rescale to match the users requirements
			return Numerics.sgxRescale(newValue, fRangeFrom, fRangeTo, fTargetScaleFrom, fTargetScaleRangeTo);
		}

	}
}