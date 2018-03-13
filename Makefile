.PHONY : test_vmtest1 test_vmtest2

test_vmtest1:
	python3 /develop/src/zmt/zmt inspect
	python3 /develop/src/zmt/zmt autosnap
	python3 /develop/src/zmt/zmt backup
	python3 /develop/src/zmt/zmt cleanup
	python3 /develop/src/zmt/zmt scripts
	@echo $$(ls /var/lib/zmt/autosnap)
	python3 /develop/src/zmt/zmt stop --kill testdocker
	python3 /develop/src/zmt/zmt start testdocker
	python3 /develop/src/zmt/zmt autosnap testdocker
	@echo '# next snapshots should be the same'
	@echo 'vmtest1:'$$(zfs list -r -t snap -o name -H tank/docker/testdocker|tail -1)
	@echo 'vmtest2:'$$(ssh vmtest2 zfs list -r -t snap -o name -H tank/docker/testdocker|tail -1)
	python3 /develop/src/zmt/zmt stop testdocker
	python3 /develop/src/zmt/zmt deactivate testdocker
	echo "# testdocker autosnap file shouldn't be listed"
	@echo $$(ls /var/lib/zmt/autosnap)
	python3 /develop/src/zmt/zmt activate testdocker
	python3 /develop/src/zmt/zmt start testdocker
	echo "# testdocker autosnap file should be listed"
	@echo $$(ls /var/lib/zmt/autosnap)
	python3 /develop/src/zmt/zmt move --container
	python3 /develop/src/zmt/zmt inspect
	@echo $$(ls /var/lib/zmt/autosnap)

test_vmtest2:
	python3 /develop/src/zmt/zmt move --container --kill
	python3 /develop/src/zmt/zmt inspect
	@echo $$(ls /var/lib/zmt/autosnap)
