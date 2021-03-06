module Php2Rb
  Program = com.caucho.quercus.program
  Expr = com.caucho.quercus.expr

  {
    Program::Function => [:statement],
    Program::ReturnStatement => [:expr],
    Program::ReturnRefStatement => [:expr],
    Program::ClassDefStatement => [:cl],
    Program::EchoStatement => [:expr],
    Program::TextStatement => [:value],
    Program::ForeachStatement => [:obj_expr, :block, :value, :key],
    Program::SwitchStatement => [:value, :cases, :blocks, :default_block],
    Program::GlobalStatement => [:var],
    Program::WhileStatement => [:test, :block],
    Program::ContinueStatement => [:target],
    Program::BreakStatement => [:target],
    Program::ForStatement => [:init, :test, :incr, :block],
    Program::ThrowStatement => [:expr],
    Program::DoStatement => [:test, :block],
    Expr::BinaryExpr => [:left, :right],
    Expr::AssignExpr => [:var, :value],
    Expr::AssignRefExpr => [:var, :value],
    Expr::StaticMethodExpr => [:class_name, :method_name, :fun, :args],
    Expr::StringLiteralExpr => [:value],
    Expr::FunctionExpr => [:args],
    Expr::ArrayFunExpr => [:keys, :values],
    Expr::ArrayGetExpr => [:expr, :index],
    Expr::MethodCallExpr => [:obj_expr, :args],
    Expr::ThisFieldExpr => [:name],
    Expr::UnaryExpr => [:expr],
    Expr::PostIncrementExpr => [:incr],
    Expr::PreIncrementExpr => [:incr],
    Expr::CharAtExpr => [:obj_expr, :index_expr],
    Expr::NewExpr => [:name, :args],
    Expr::LongLiteralExpr => [:value],
    Expr::ConditionalExpr => [:test, :true_expr, :false_expr],
    Expr::ThisFieldExpr => [:name],
    Expr::ArrayTailExpr => [:expr],
    Expr::FieldGetExpr => [:obj_expr, :name],
    Expr::UnsetVarExpr => [:var],
    Expr::ListHeadExpr => [:var_list, :key_list],
    Expr::ListExpr => [:list_head, :value],
    Expr::ClassMethodExpr => [:name, :args],
    Expr::InstanceOfExpr => [:right],
    Expr::ThisFieldVarGetExpr => [:name_expr],
    Expr::ClassConstExpr => [:name],
    Expr::VarNewExpr => [:name, :args],
    Expr::VarExpr => [:name]
  }.each do |klass, keys|
    klass.instance_eval do
      keys.each do |key|
        java_key = key.to_s.camel_case
        java_key = java_key[0..0].downcase + java_key[1..-1]
        field_reader :"_#{java_key}" => key
      end
    end
  end

end

