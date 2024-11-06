class Paciente {
  var edad
  var fortalezaMuscular
  var dolor
  const rutina = []

  method edad()=edad
  method fortalezaMuscular()=fortalezaMuscular
  method dolor()=dolor
  method disminuirDolor(unValor){
    dolor = 0.max(dolor - unValor)
  }
  method aumentarFortaleza(unValor){
    fortalezaMuscular += unValor
  }
  method puedeUsar(unAparato){
    return unAparato.puedeSerUsadoPor(self)
  }
  method usar(unAparato){
    if (self.puedeUsar(unAparato)){
      unAparato.consecuenciaDelUso(self)
    }
  }
  method cumplirAnios(){edad+=1}
  method agregarAparatoARutina(unAparato){
    rutina.add(unAparato)
  }
  method cargarRutina(unaLista){
    rutina.clear()
    rutina.addAll(unaLista)
  }
  method puedeHacerRutina(){
    return rutina.all({a=>self.puedeUsar(a)})
  }
  method hacerRutina(){
    rutina.forEach({a=>self.usar(a)})
  }
}
class Resistente inherits Paciente {
  override method hacerRutina(){
    super()
    self.aumentarFortaleza(
      rutina.count({a=>self.puedeUsar(a)})
      )
  }
}
class Caprichoso inherits Paciente {
  override method puedeHacerRutina(){
    return super() and rutina.any({a=>a.color()=='Rojo'})
  }
  override method hacerRutina(){
    super()
    super()
  }
}
class RapidaRecuperacion inherits Paciente {
  override method hacerRutina(){
    super()
    self.disminuirDolor(recuperacion.valor())
  }
}
object recuperacion {
  var property valor = 3
}
class Aparato {
  var property color = 'Blanco'
  method puedeSerUsadoPor(unPaciente)
  method consecuenciaDelUso(unPaciente)
  method necesitaMantenimiento()
  method recibirMantenimiento()
}

class Magneto inherits Aparato {
  var imantacion = 800
  override method puedeSerUsadoPor(unPaciente) {
    return true
  }
  override method consecuenciaDelUso(unPaciente){
    unPaciente.disminuirDolor(unPaciente.dolor()*0.1)
    imantacion-=1
  }
  override method necesitaMantenimiento(){
    return imantacion<100
  }
  override method recibirMantenimiento(){
    imantacion+=500
  }
}

class Bicicleta inherits Aparato {
  var desajusteTornillos = 0
  var perdidaAceite = 0
  override method puedeSerUsadoPor(unPaciente){
    return unPaciente.edad()>8
  }
  override method consecuenciaDelUso(unPaciente){
    const dolorPaciente = unPaciente.dolor()
    unPaciente.disminuirDolor(4)
    unPaciente.aumentarFortaleza(3)
    if (dolorPaciente>30){
      desajusteTornillos+=1
    }
    if (unPaciente.edad()>=30 and unPaciente.edad()<=50){
      perdidaAceite+=1
    }
  }
  override method necesitaMantenimiento(){
      return desajusteTornillos>=10 or perdidaAceite>=5
    }
  override method recibirMantenimiento(){
    desajusteTornillos=0
    perdidaAceite=0
  }
}

class Minitramp inherits Aparato {
  override method puedeSerUsadoPor(unPaciente){
    return unPaciente.dolor()<20
  }  
  override method consecuenciaDelUso(unPaciente){
    unPaciente.aumentarFortaleza(unPaciente.edad()*0.1)
  }
  override method necesitaMantenimiento()=false
  override method recibirMantenimiento(){}
}

object centro {
  const pacientes = []
  const aparatos = []
  method agregarPacientes(unaLista){
    pacientes.addAll(unaLista)
  }
  method agregarAparatos(unaLista){
    aparatos.addAll(unaLista)
  }
  method coloresAparatos(){
    aparatos.map({a=>a.color()}).asSet()
  }
  method pacientesMenoresA(unaEdad){
    pacientes.filter({p=>p.edad()<unaEdad})
  }
  method cantidadPacientesNoPuedenHacerRutina(){
    pacientes.count({p=>not p.puedeHacerRutina()})
  }
  method estaEnOptimasCondiciones(){
    return aparatos.all({a=>not a.necesitaMantenimiento()})
  }
  method estaComplicado(){
    return aparatos.count({a=>a.necesitaMantenimiento()})>=aparatos.size()/2
  }
  method visitaTecnico(){
    aparatos.forEach({a=>a.recibirMantenimiento()})
  }
}