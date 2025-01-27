#include <VlppWorkflowCompiler.h>

using namespace vl;
using namespace vl::console;
using namespace vl::collections;
using namespace vl::parsing;
using namespace vl::reflection;
using namespace vl::reflection::description;
using namespace vl::workflow;
using namespace vl::workflow::emitter;
using namespace vl::workflow::runtime;

namespace myapi
{
	class App : public Object, public Description<App>
	{
	public:
		static WString Get()
		{
			return Console::Read();
		}

		static WString Get(const WString& message)
		{
			Console::Write(message);
			return Console::Read();
		}

		static void Print(const WString& text)
		{
			Console::WriteLine(text);
		}
	};

	class IScripting : public virtual IDescriptable, public Description<IScripting>
	{
	public:
		virtual void Execute(const WString& name) = 0;
	};
}

#define MYAPI_TYPELIST(F)\
	F(myapi::App)\
	F(myapi::IScripting)\

namespace vl
{
	namespace reflection
	{
		namespace description
		{
			MYAPI_TYPELIST(DECL_TYPE_INFO)
			MYAPI_TYPELIST(IMPL_CPP_TYPE_INFO)

			using namespace myapi;

#pragma warning(push)
#pragma warning(disable:4250)
			BEGIN_INTERFACE_PROXY_SHAREDPTR(IScripting)
				void Execute(const WString& name)override
				{
					INVOKE_INTERFACE_PROXY(Execute, name);
				}
			END_INTERFACE_PROXY(IScripting)
#pragma warning(pop)

#define _ ,

			BEGIN_CLASS_MEMBER(App)
				CLASS_MEMBER_STATIC_METHOD_OVERLOAD(Get, NO_PARAMETER, WString(*)())
				CLASS_MEMBER_STATIC_METHOD_OVERLOAD(Get, { L"message" }, WString(*)(const WString&))
				CLASS_MEMBER_STATIC_METHOD(Print, { L"text" })
			END_CLASS_MEMBER(App)

			BEGIN_INTERFACE_MEMBER(IScripting)
				CLASS_MEMBER_METHOD(Execute, { L"name" })
			END_INTERFACE_MEMBER(IScripting)

#undef _
			class MyApiTypeLoader : public Object, public ITypeLoader
			{
			public:
				void Load(ITypeManager* manager)
				{
					MYAPI_TYPELIST(ADD_TYPE_INFO)
				}

				void Unload(ITypeManager* manager)
				{
				}
			};
		}
	}
}

const wchar_t ScriptCode[] = LR"Workflow(

module sampleModule;

using myapi::*;

func main(): IScripting^
{
	return new IScripting^
	{
		override func Execute(name: string): void
		{
			App::Print($"Hello, $(name)!");
		}
	};
}

)Workflow";

int main()
{
	// start reflection
	LoadPredefinedTypes();
	WfLoadLibraryTypes();
	GetGlobalTypeManager()->AddTypeLoader(new MyApiTypeLoader);
	GetGlobalTypeManager()->Load();

	{
		// prepare Workflow script code
		List<WString> codes;
		codes.Add(WString::Unmanaged(ScriptCode));

		// compile code and get assemblies
		List<Ptr<ParsingError>> errors;
		auto table = WfLoadTable();
		auto assembly = Compile(table, codes, errors);
		CHECK_ERROR(assembly && errors.Count() == 0, L"Please check the 'errors' variable.");

		// initialize the assembly
		auto globalContext = MakePtr<WfRuntimeGlobalContext>(assembly);
		auto initializeFunction = LoadFunction<void()>(globalContext, L"<initialize>");
		initializeFunction();

		// call main
		auto mainFunction = LoadFunction<Ptr<myapi::IScripting>()>(globalContext, L"main");
		mainFunction()->Execute(L"Gaclib");
	}

	// stop reflection
	DestroyGlobalTypeManager();
}