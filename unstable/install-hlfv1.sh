(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �]Y��ʶ���
��o��q�IQAAD�ƍ
f'AE���������*v�h��n43I�\��[+{e��d_��2���__� M��+J�����Bq�q�h�/�1��F~Msc����V�k���i�r�����p�?������rz���x�}ʈ�\�MR����[�MAe \,!��x���>�.�?JRH%�2p�����+���p��	�������?���:N�7���*���k���N�;�����q0Ew�~z-�=�h, (J҅�����<��8^�V��)>g���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d_5�*��2������I�����#]Ԑ2:���WGpbCVk"/�A���&0�Z[�Ny��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[��������Щ��*���tG�����o{�t����u�����R�%���qu�z��уg���QǞ���)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`�7O�m�w���q'�ǅ������b<j����)1�C�Aɕ��`!��C.��z�O�-A�(`~n�D�MSى�C�C�����������N���9�5�țr7�6�8Xs�*���f�b.�~�|������[K���
�4���6A(�(:})( 2�T_#Bi���Ю/滑D���H���`��Ɗ�Q+S��_vЦ�6��0�Y�%C��#�w��f��9�[ݙ��\����� �������k�Q���N}��=/�����V�x.,)@�@�����u���(��EƤ����7+&@fK��(�t isy�1����R��(y��@����u��@.|[$�%���1�e�����}v�7��k�r�-'iKj����Ũ��,��Ez ǢϙE/�f�\�}X|`6<����,����i�����P��$�?Jj����S��P
��������'����G�y��S��]��H��9Zr;ˇr$��B?c�K����P�I9�S�bqU0U��"��~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+��)�)�a�P_�&N�&.�n��s���2�M���4���j�vZ�b�w� 4��[�.u��z��3w�V�J�Bx��К0
�-�G�H�-MSΌ�5 �$./�@���y����*�q���1�����8�t�܇�.��w|K3ymJ
�(�Hs?4���\rآQ��R�l�9��L�k|'p$�,���&��/�D�0����t��<�1>�@��亖L��)�fV}ȡ�a��?�����k���?��$IU���S������G��F����@��W�������/��w�^��D�V�_~I�_�S�������~}��>E8�b�P6[\� �H���0M���H@�.���Ca��(��tg=ҫ��)�!�7�����P$]�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ���(~i�e�O�_
>K���CT��T���_��W��}H�e�O�������(�3�*���/�gz����C��!|��l����;�f���w�бY��G�Ǧ��|h ���N���p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��+�Ȋ����������KA��W����������k����-L�����%���_��������T�_���.���(��@�"�����%��16���ӏ:��O8C������빁[�8�(���H��>��,IRv�����_���V�e���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߇�x�ǩ租~���?J��9x��$~����P�����B��~�L)\.�D��_
>*���_V�˟�w��	�L����b��(�V�K���������t��S�d��4B�?��9�m�.cS,���x.����a�G#�n�8K0A��6˰>Z-��2����������t����0Qx1�v�z���`�]��c��F����_\�Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l�Z��0>s�����AW�_)��?�$���W�_���� ��h�
e���a���4��(l���+o����_����΁X�qе
�%,�!?;�y<���%�������a�Ui��U��n�/���CwA�����h�� 菞=hZ�a��-
'���N����B�N{Ġ�7��j�66a�'�E�\�n�Y=�c�1<�j2�:�޼9��\�t���[q�\R|o6h&*�n�Q�z���b��G�y��p���s��i�X�s�%?���ԕsY�Hњ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>��nk�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i��Ń}��i;������R�[��^����f��$�r~K�!�7��g�?	���/���ѿ��1nۯ�x7w��i*�;<��}���{C��<3���#� ����} �'�@���-��) ��i����5^9zp Dbl'�����>���$���ld�l�k��e+=5%���ʱkiBÐNe3&ɜ��ep*7<��k����q�W��[�A@O�x�ygs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>S��t���Q���+���O>��������������e��#���������G��_��W�����;���N�����0����rp��/��.��B�*��T�_���.���?�|�����Rp9�a�4��$J1E����>�Q$�8�N�8��(��S��庘�0^��[���a�����S�Ge�}=.����)�rrط̩�f�/0DhN=���l��y�-Z����?� ��q[iXW��E��5��ľ����UQRs̡��+8��)L�Z:Yg�Q�&���F}���ش������ݹ��?J�̿�G���������/�U��U
�~�Z�[�o�o��t;u��T��6r��j���o��>�Ӆ��tl'��W��m�P7q�^#�ȕ�H&������2��s%��UM�.�7<�iv�;�]���^�᧧�8]g?����ķ�?�9�7��޷Z6�]�����Q;�w]�*R����t���|���~,t�+���������jWN�������$��v坺`/6������KNu��޷����ڞ.��fiGŨp훻ʠ����p;r���}cX��hluuA�E��!��:7�o�*]���#ק?/�>^�r_�fW�~��[E%��|��^�q������\;�BϾ��.:J�'߻��/o�d�y�,�3�^����o���:b��"{�e�%o�� ��O[/�������y��N���ͷWkӻ]�����zU������3�X��O[ �����SS�8�O��7M���8Y�a���	��.Nד�s]���L�GR��j�h�B"GE��L	����}7@���~�ȇ#�x쩛�NYo�c������	d��
�8��!�"v�w�h�<.��#��:����M��3B�+����r����$����N�t��ϖ�u�p����Ÿ-����{�UT��o{W�:Y��r���C	r9�e�p1�x��CE�n�v�n��7%מ�k�ukO�wb��L|	�7	!~ b������E��"h0ĈBL�h�m=��v���pA�s�{��������{����<O:c�lr�rSn%d"v���D2A�")<]F;�Y#�L&���LG�a\��e혀��I��,/L��p:�ǭ��7�r`��ѱ��b 6t/��5 h��s�3�ۄ�J�ńq!v�E�Q�%I������v��k�&��u#��
�k�Cn��4�0�Rt�kq���3V3EL<�d�v[�t�ԵQ�w����|x�Y����P�����&3ّ鶐-$��[�'�%��*|��H�w�w�8g܄�e���_3�\We�ДF�#!2�R��8�.�F�j�5�w���Bi1^2f^�[��[7gyQc4E��)��F�E�E�e�6��Q�ti&Nm8=�����_�S�;��ɉ����4�b|�\]������iU��=�s�g�w�yN��S�9�uPK�!ˠ�Hҩ��#U��q���YG�S���=�Re�EXs�7#�ˈ�H���׌�����|t�D��8��U���.s�fGW���u�q�]d��SyV��R�6y����U�.r�\�lQ�I�Z;[3o u��j����g��d&/G��O�����g�uT�h��*�7V�x�s.���=��k�n���4m&?�t눅��8/��f��8��ˈ	���91�{�*���v.����7��Z��|WW�%�Ѕ����÷9Z���������3w��T��WU�1�p�i�捣�����#`>��&�m�߭:����F��f��������w?�W��!PX;�qj��?���Z*q�m����<�j �S��ȶ�W���¶�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*��sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I��9a�\/L�A��-��mf�7
�t��D�T��F�Hn��m�K��bg�Y��D?C�ݜ�����C�+��f�v�r/��|i����;]P�d�8̣X���'�9��-F�%��G��~��݂�0I��F���a�]��=L��~����юp�S��,>^$����YB�tv�W2��TQp�	�T����|��R^�+`XNU[BLHz.%5XHh[%U�)�͇���K�)Nz��R��C�\ڏ�=}�f��LX�	�
z�@��K티�M=u��6��D�����!\�kO͕�u��`�ck�tM�F�xP�*�'����&�e���G�~ee�h.O�B��j�Z�;J��0�m����D�!��$3�0i$]N�L�D�ɰX��'�9d�#<#;V0��x'�	���*�!VI�����.֊�x���|�&��4/^�@�0J��t}�3�r�t3��ۉx��R4���z��ǘȾ�h���>&eY�댲l�3����r)���TJÁߝhpp��$_�h��p�h8��mi�+�|+�Zb�
��b+-_�ʕ�A4���)�Ht^+JT�RU@�4�c�x�%��e����Re��<�+�ѴoHZ��ѭ+r���N$*g=�x�q�T���Z�yw�
�n!A�JFj~$�d��^��t�b	��U�[e�-R��e��,��%��z<C!�V�ˣ$���@HP� ACwR��fn��ya����^jX@�J�(o��ډa�\e�nu����@@N��,a1Y�b��E�@YIo�I�ҙ2� sʲGxFv��0�M�;�a|o�Uk}Z(�L�Y�W��K9o6�s�>t��7���#�}��rmB��<��g(F�I�-G�A��I;f?eq�>����>�j>��)��iN\SPkm^ՠ�@�֮�6�5�����g��_��L0>�.@]���<�Й�<�WNW���ʡ�ڸ\dۜh���N��\�����%r78C���9(%K5n ��n�9�Wڸ$�Nn�	n"F1�4��՚�UC�֦������-��e
�C��IM�dK�	�5[��y�f��X��琳?�n�iu�Y���U��^?a�\ 7
`��j���-������*��6Kf|bZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Fֿ�:�G���ס�֡���g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m��11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷Ne�:me��y'��@˽����ct�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹���X!��RHn�0��Ep���m6�jb�%d�j�kwT3Z��=�0%�>�h╊�k��v�~��k����BqI��[���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��N�i�D�c��@�'�ݻ���k�?/K�ǳ���'�ݗ�8��_������M}�ɯ�@���I�{q�T|'��ֵ+�_���=���t�Zڀξ������3_l�N��3NϿ^�ͯ�COB�S�5
�#�i����zs����M����6�Ӧ	�4��i�}�ŵ�v@ڦv��N��i�l���~�v�oy��A�\��g	#�0�M�M^�n[D�d<b��[��:�c��{ȟ�8�6EMx�y�[g��O���T�g`�m����#�.��r�^��f��Ӳ����V{Ό=-��`ϙ���6��0g��}�0�r�̹p�a�C��V�m����c$s���5p�蟝�d';��}����]  