#|**************************************************
  robot�����Ф�Ĥʤ��ǡ�ȿ��ư����Ƥߤ���ñ����
  bumper�򲡤�������֤�ư��

  �Ĥʤ����simulator, �µ����ڤ��ؤ��������
  Ʊ����ư�ץ�����बư���褦�ˤʤäƤ�����

  2010/12/1 written by nakanish

**************************************************|#
(load "robot-server-simulator.l")            ;;simulator�ȤĤʤ�����δؿ��Υ�����
(load "../client/eus-client/robot-client.l") ;;�µ��ȤĤʤ�����δؿ��Υ�����

(warn "(demo)         ;;���ߥ�졼������³����ȿ����ư~%")
(warn "(demo :real t) ;;�µ�����³����ȿ����ư~%")
(defun demo
  (&key (real nil))
  (let (result) ;;�ɽ��ѿ������
    ;;
    ;;�µ������ߥ�졼����������ˤ�ä���³����ѹ�
    (cond
     (real
      (setq *rs* (connect-robot-server)))
     (t
      (setq *rs* (connect-robotsim-server))))
    ;; 
    #| ************************************************
      ȿ����ư�ץ��������ʬ(��������Ǹ�ޤ�)
        sample.l��sample-sim.l�Ȥޤä���Ʊ��
        (��������sample-sim�ξ���*rs-sim*�˥Х���ɤ��Ƥ�������*rs*���ѹ����Ƥ���Ȥ������Τ߰㤦

       ���ߥ�졼���Ǥ�µ��Ǥ�ޤä���Ʊ���ץ�����बư���Ƥ���Τ�̣��!!
    ***************************************************|#

    ;;��֤�����⡼�ɤ����������ѹ�����
    (send *rs* :daisya-controlmode 2)
    ;;key�򲡤����ޤ�³����
    (do-until-key
     ;;bumper�ξ��֤��������(6�Ĥ����Ǥ���ʤ�٥��ȥ뤬���äƤ���Ϥ�)
     (setq result (send *rs* :bumper-vector))
     ;;bumper�ξ��֤�ɽ������(6�Ĥ����Ǥ���ʤ�٥��ȥ뤬ɽ�������Ϥ�)
     (warn "bumper-vector:~a~%" result)
     ;;bumper�ξ��֤˱�������֤ε�ư���ѹ�
     (cond
      ;;bumper0,���뤤��bumper5��������Ƥ������
      ((or (= (elt result 0) 1) (= (elt result 5) 1))
       ;;1�ä�����300[mm]�Хå�&��ž����
       (send *rs* :daisya-position-vector #f(-300 0 50) 1000)
       ;;1�õ٤�
       (unix:sleep 1)
       )
      ;;bumper2,���뤤��bumper3��������Ƥ������
      ((or (= (elt result 2) 1) (= (elt result 3) 1))
       (send *rs* :daisya-position-vector #f(300 0 0) 1000)
       (unix:sleep 1)
       )
      ;;bumper4��������Ƥ������
      ((= (elt result 4) 1)
       (send *rs* :daisya-position-vector #f(0 200 0) 1000)
       (unix:sleep 1)
       )
      ;;bumper1��������Ƥ������
      ((= (elt result 1) 1)
       (send *rs* :daisya-position-vector #f(0 -200 0) 1000)
       (unix:sleep 1)
       )
      ;;����ʳ��ξ��
      (t
       ;;�Ȥꤢ����ľ��, usleep�ϥޥ��������꡼�פΰ�̣
       (send *rs* :daisya-position-vector #f(300 0 0) 1000)
       (unix:usleep (* 1000 1000))
       ))
     )
    ;;��������®��������ᤷ�Ƥ���(�Ĥ��Ǥ�speed��0�ˤ��Ƥ���)
    (send *rs* :daisya-controlmode 1)
    (send *rs* :daisya-velocity-vector #f(0 0 0))
    ))