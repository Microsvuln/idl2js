dictionary WebAssemblyInstantiatedSource {
    required Module module;
    required Instance instance;
};

[Exposed=(Window,Worker,Worklet)]
namespace WebAssembly {
    boolean validate(BufferSource bytes);
    Promise<Module> compile(BufferSource bytes);

    Promise<WebAssemblyInstantiatedSource> instantiate(
        BufferSource bytes, optional object importObject);

    Promise<Instance> instantiate(
        Module moduleObject, optional object importObject);
};

enum ImportExportKind {
  "function",
  "table",
  "memory",
  "global"
};

dictionary ModuleExportDescriptor {
  required USVString name;
  required ImportExportKind kind;
  // Note: Other fields such as signature may be added in the future.
};

dictionary ModuleImportDescriptor {
  required USVString module;
  required USVString name;
  required ImportExportKind kind;
};

[LegacyNamespace=WebAssembly, Exposed=(Window,Worker,Worklet)]
interface Module {
  constructor(BufferSource bytes);
  static sequence<ModuleExportDescriptor> exports(Module moduleObject);
  static sequence<ModuleImportDescriptor> imports(Module moduleObject);
  static sequence<ArrayBuffer> customSections(Module moduleObject, DOMString sectionName);
};

[LegacyNamespace=WebAssembly, Exposed=(Window,Worker,Worklet)]
interface Instance {
  constructor(Module module, optional object importObject);
  readonly attribute object exports;
};

dictionary MemoryDescriptor {
  required [EnforceRange] unsigned long initial;
  [EnforceRange] unsigned long maximum;
};

[LegacyNamespace=WebAssembly, Exposed=(Window,Worker,Worklet)]
interface Memory {
  constructor(MemoryDescriptor descriptor);
  unsigned long grow([EnforceRange] unsigned long delta);
  readonly attribute ArrayBuffer buffer;
};

enum TableKind {
  "externref",
  "anyfunc",
  // Note: More values may be added in future iterations,
  // e.g., typed function references, typed GC references
};

dictionary TableDescriptor {
  required TableKind element;
  required [EnforceRange] unsigned long initial;
  [EnforceRange] unsigned long maximum;
};

[LegacyNamespace=WebAssembly, Exposed=(Window,Worker,Worklet)]
interface Table {
  constructor(TableDescriptor descriptor, optional any value);
  unsigned long grow([EnforceRange] unsigned long delta, optional any value);
  any get([EnforceRange] unsigned long index);
  undefined set([EnforceRange] unsigned long index, optional any value);
  readonly attribute unsigned long length;
};

enum ValueType {
  "i32",
  "i64",
  "f32",
  "f64",
  "v128",
  "externref",
  "anyfunc",
};

dictionary GlobalDescriptor {
  required ValueType value;
  boolean mutable = false;
};

[LegacyNamespace=WebAssembly, Exposed=(Window,Worker,Worklet)]
interface Global {
  constructor(GlobalDescriptor descriptor, optional any v);
  any valueOf();
  attribute any value;
};