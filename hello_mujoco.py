import mujoco
import mujoco.viewer  # a submodule: import it / alt modül: ayrıca yükle

XML = """
<mujoco>
  <asset>
    <texture name="grid" type="2d" builtin="checker" width="512"
             height="512" rgb1=".34 .35 .37" rgb2=".38 .39 .41"/>
    <material name="grid" texture="grid" texrepeat="8 8" reflectance=".12"/>
  </asset>
  <worldbody>
    <light pos="0 0 3" directional="true"/>
    <geom type="plane" size="2 2 .1" material="grid"/>
    <body pos="0 0 1" euler="20 30 0">
      <freejoint/>
      <geom type="box" size=".1 .1 .1" rgba="1 .45 .1 1"/>
    </body>
    <body pos=".35 .1 1.5">
      <freejoint/>
      <geom type="sphere" size=".08" rgba=".2 .6 1 1" solref="-8000 -20"/>
    </body>
  </worldbody>
</mujoco>
"""

model = mujoco.MjModel.from_xml_string(XML)  # fixed description / sabit tanım
data = mujoco.MjData(model)                  # changing state / değişen durum
mujoco.viewer.launch(model, data)            # window + physics / pencere + fizik
