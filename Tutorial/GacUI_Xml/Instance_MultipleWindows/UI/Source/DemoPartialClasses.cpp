﻿/***********************************************************************
!!!!!! DO NOT MODIFY !!!!!!

GacGen.exe Resource.xml

This file is generated by Workflow compiler
https://github.com/vczh-libraries
***********************************************************************/

#include "Demo.h"
/* CodePack:BeginIgnore() */
#ifndef VCZH_DEBUG_NO_REFLECTION
/* CodePack:ConditionOff(VCZH_DEBUG_NO_REFLECTION, DemoReflection.h) */
#include "DemoReflection.h"
#endif
/* CodePack:EndIgnore() */

#if defined( _MSC_VER)
#pragma warning(push)
#pragma warning(disable:4250)
#elif defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wparentheses-equality"
#elif defined(__GNUC__)
#pragma GCC diagnostic push
#endif

#define GLOBAL_SYMBOL ::vl_workflow_global::Demo::
#define GLOBAL_NAME ::vl_workflow_global::Demo::Instance().
#define GLOBAL_OBJ &::vl_workflow_global::Demo::Instance()

/***********************************************************************
Global Variables
***********************************************************************/

BEGIN_GLOBAL_STORAGE_CLASS(vl_workflow_global_Demo)
	vl_workflow_global::Demo instance;
	INITIALIZE_GLOBAL_STORAGE_CLASS
	FINALIZE_GLOBAL_STORAGE_CLASS
END_GLOBAL_STORAGE_CLASS(vl_workflow_global_Demo)

namespace vl_workflow_global
{
/***********************************************************************
Global Functions
***********************************************************************/

	Demo& Demo::Instance()
	{
		return Getvl_workflow_global_Demo().instance;
	}

/***********************************************************************
Closures
***********************************************************************/

	//-------------------------------------------------------------------

	__vwsno1_Demo_demo_MainWindowConstructor___vwsn_demo_MainWindow_Initialize_::__vwsno1_Demo_demo_MainWindowConstructor___vwsn_demo_MainWindow_Initialize_(::demo::MainWindow* __vwsnctor___vwsn_this_, ::demo::MainWindowConstructor* __vwsnctorthis_0)
		:__vwsn_this_(__vwsnctor___vwsn_this_)
		, __vwsnthis_0(::vl::__vwsn::This(__vwsnctorthis_0))
	{
	}

	void __vwsno1_Demo_demo_MainWindowConstructor___vwsn_demo_MainWindow_Initialize_::operator()(::vl::presentation::compositions::GuiGraphicsComposition* __vwsno_1, ::vl::presentation::compositions::GuiEventArgs* __vwsno_2) const
	{
		return ::vl::__vwsn::This(__vwsn_this_)->buttonShowWindow_Clicked(__vwsno_1, __vwsno_2);
	}
}

/***********************************************************************
Class (::demo::AnotherWindowConstructor)
***********************************************************************/

namespace demo
{
	void AnotherWindowConstructor::__vwsn_demo_AnotherWindow_Initialize(::demo::AnotherWindow* __vwsn_this_)
	{
		(this->__vwsn_precompile_0 = __vwsn_this_);
		(this->__vwsn_precompile_2 = ::vl::__vwsn::This(this->__vwsn_precompile_0)->GetContainerComposition());
		{
			::vl::__vwsn::This(this->__vwsn_precompile_2)->SetPreferredMinSize([&](){ ::vl::presentation::Size __vwsn_temp__; __vwsn_temp__.x = static_cast<::vl::vint>(320); __vwsn_temp__.y = static_cast<::vl::vint>(280); return __vwsn_temp__; }());
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_0)->SetClientSize([&](){ ::vl::presentation::Size __vwsn_temp__; __vwsn_temp__.x = static_cast<::vl::vint>(320); __vwsn_temp__.y = static_cast<::vl::vint>(280); return __vwsn_temp__; }());
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_0)->SetText(::vl::WString::Unmanaged(L"Another Window"));
		}
		{
			(this->__vwsn_precompile_1 = new ::vl::presentation::controls::GuiLabel(::vl::presentation::theme::ThemeName::Label));
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_1)->SetFont(::vl::Nullable<::vl::presentation::FontProperties>([&](){ ::vl::presentation::FontProperties __vwsn_temp__; __vwsn_temp__.fontFamily = ::vl::WString::Unmanaged(L"Segoe UI"); __vwsn_temp__.size = static_cast<::vl::vint>(32); __vwsn_temp__.antialias = true; return __vwsn_temp__; }()));
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_1)->SetText(::vl::WString::Unmanaged(L"This is another window!"));
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_0)->AddChild(static_cast<::vl::presentation::controls::GuiControl*>(this->__vwsn_precompile_1));
		}
	}

	AnotherWindowConstructor::AnotherWindowConstructor()
		: __vwsn_precompile_0(static_cast<::demo::AnotherWindow*>(nullptr))
		, __vwsn_precompile_1(static_cast<::vl::presentation::controls::GuiLabel*>(nullptr))
		, __vwsn_precompile_2(static_cast<::vl::presentation::compositions::GuiGraphicsComposition*>(nullptr))
	{
	}

/***********************************************************************
Class (::demo::AnotherWindow)
***********************************************************************/

	AnotherWindow::AnotherWindow()
		: ::vl::presentation::controls::GuiWindow(::vl::presentation::theme::ThemeName::Window)
	{
		auto __vwsn_resource_ = ::vl::__vwsn::This(::vl::presentation::GetResourceManager())->GetResourceFromClassName(::vl::WString::Unmanaged(L"demo::AnotherWindow"));
		auto __vwsn_resolver_ = ::vl::Ptr<::vl::presentation::GuiResourcePathResolver>(new ::vl::presentation::GuiResourcePathResolver(__vwsn_resource_, ::vl::__vwsn::This(__vwsn_resource_.Obj())->GetWorkingDirectory()));
		::vl::__vwsn::This(this)->SetResourceResolver(__vwsn_resolver_);
		::vl::__vwsn::This(this)->__vwsn_demo_AnotherWindow_Initialize(this);
	}

	AnotherWindow::~AnotherWindow()
	{
		this->FinalizeInstanceRecursively(static_cast<::vl::presentation::controls::GuiControlHost*>(this));
	}

/***********************************************************************
Class (::demo::MainWindowConstructor)
***********************************************************************/

	void MainWindowConstructor::__vwsn_demo_MainWindow_Initialize(::demo::MainWindow* __vwsn_this_)
	{
		(this->__vwsn_precompile_0 = __vwsn_this_);
		(this->__vwsn_precompile_3 = ::vl::__vwsn::This(this->__vwsn_precompile_0)->GetContainerComposition());
		{
			::vl::__vwsn::This(this->__vwsn_precompile_3)->SetPreferredMinSize([&](){ ::vl::presentation::Size __vwsn_temp__; __vwsn_temp__.x = static_cast<::vl::vint>(480); __vwsn_temp__.y = static_cast<::vl::vint>(320); return __vwsn_temp__; }());
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_0)->SetClientSize([&](){ ::vl::presentation::Size __vwsn_temp__; __vwsn_temp__.x = static_cast<::vl::vint>(480); __vwsn_temp__.y = static_cast<::vl::vint>(320); return __vwsn_temp__; }());
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_0)->SetText(::vl::WString::Unmanaged(L"Instance_MultipleWindows"));
		}
		{
			(this->__vwsn_precompile_1 = new ::vl::presentation::controls::GuiButton(::vl::presentation::theme::ThemeName::Button));
		}
		(this->__vwsn_precompile_2 = ::vl::__vwsn::This(this->__vwsn_precompile_1)->GetBoundsComposition());
		{
			::vl::__vwsn::This(this->__vwsn_precompile_2)->SetMargin([&](){ ::vl::presentation::Margin __vwsn_temp__; __vwsn_temp__.left = static_cast<::vl::vint>(20); __vwsn_temp__.top = static_cast<::vl::vint>(20); __vwsn_temp__.right = (- static_cast<::vl::vint>(1)); __vwsn_temp__.bottom = (- static_cast<::vl::vint>(1)); return __vwsn_temp__; }());
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_1)->SetText(::vl::WString::Unmanaged(L"Click me to show another window!"));
		}
		{
			::vl::__vwsn::This(this->__vwsn_precompile_0)->AddChild(static_cast<::vl::presentation::controls::GuiControl*>(this->__vwsn_precompile_1));
		}
		{
			::vl::__vwsn::EventAttach(::vl::__vwsn::This(this->__vwsn_precompile_1)->Clicked, vl::Func(::vl_workflow_global::__vwsno1_Demo_demo_MainWindowConstructor___vwsn_demo_MainWindow_Initialize_(__vwsn_this_, this)));
		}
	}

	MainWindowConstructor::MainWindowConstructor()
		: __vwsn_precompile_0(static_cast<::demo::MainWindow*>(nullptr))
		, __vwsn_precompile_1(static_cast<::vl::presentation::controls::GuiButton*>(nullptr))
		, __vwsn_precompile_2(static_cast<::vl::presentation::compositions::GuiBoundsComposition*>(nullptr))
		, __vwsn_precompile_3(static_cast<::vl::presentation::compositions::GuiGraphicsComposition*>(nullptr))
	{
	}

}
#undef GLOBAL_SYMBOL
#undef GLOBAL_NAME
#undef GLOBAL_OBJ

#if defined( _MSC_VER)
#pragma warning(pop)
#elif defined(__clang__)
#pragma clang diagnostic pop
#elif defined(__GNUC__)
#pragma GCC diagnostic pop
#endif
