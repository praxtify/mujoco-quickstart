import mujoco
import mujoco.viewer  # viewer is a submodule: import it explicitly / viewer alt modül: ayrıca import et

XML = """
<mujoco>
  <asset>
    <texture name="grid" type="2d" builtin="checker" width="512" height="512"
             rgb1="0.34 0.35 0.37" rgb2="0.38 0.39 0.41"/>
    <material name="floor" texture="grid" texrepeat="8 8" reflectance="0.12"/>
  </asset>
  <worldbody>
    <light pos="0 0 3" dir="0 0 -1" directional="true"/>
    <geom type="plane" size="2 2 0.1" material="floor"/>
    <body pos="0 0 1" euler="20 30 0">
      <freejoint/>
      <geom type="box" size="0.1 0.1 0.1" rgba="1 0.45 0.1 1"/>
    </body>
    <body pos="0.35 0.1 1.5">
      <freejoint/>
      <geom type="sphere" size="0.08" rgba="0.2 0.6 1 1" solref="-8000 -20"/>
    </body>
  </worldbody>
</mujoco>
"""

model = mujoco.MjModel.from_xml_string(XML)  # fixed description / sabit tanım
data = mujoco.MjData(model)                  # changing state / değişen durum

mujoco.viewer.launch(model, data)            # opens the window and runs the physics / pencereyi açar, fiziği koşturur
